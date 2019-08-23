use v6;
use NativeCall;

use XML::Actions;

use Gnome::Gtk3::Glade::Engine;
use Gnome::Gtk3::Glade::Engine::Test;

use Gnome::GObject::Object;
use Gnome::GObject::Signal;
use Gnome::Gdk3::Screen;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::StyleProvider;
use Gnome::Gtk3::CssProvider;
use Gnome::Gtk3::StyleContext;

# Pick the extremities of modules to get all depending modules.
use Gnome::Gtk3::AboutDialog;
use Gnome::Gtk3::FileChooserDialog;
use Gnome::Gtk3::RadioButton;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Entry;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Glade::Engine::Work:auth<github:MARTIMM> is XML::Actions::Work;

has Gnome::Gdk3::Screen $!gdk-screen;
has Gnome::Gtk3::Main $!main;
has Gnome::Gtk3::Builder $.builder;
has Gnome::Gtk3::CssProvider $!css-provider;
has Gnome::Gtk3::StyleContext $!style-context;

has Array $!engines;

#-------------------------------------------------------------------------------
submethod BUILD ( ) {

  # initializing GTK is done in Engine because it lives before Work
  $!main .= new;
  $!gdk-screen .= new(:default);
  $!css-provider .= new(:empty);
  $!style-context .= new(:empty);

  $!engines = [];
}

#-----------------------------------------------------------------------------
method glade-add-engine ( Gnome::Gtk3::Glade::Engine:D $engine ) {

#TODO init in BUILD first then add etc
  $!engines.push($engine);
}

#-------------------------------------------------------------------------------
# Prefix all methods with 'glade-' to distinguish them from callback methods
# for glade gui xml elements when that file is processed by XML::Actions
#-------------------------------------------------------------------------------
multi method glade-add-gui ( Str:D :$ui-file! ) {

  if ?$!builder {
    my $error-code = $!builder.gtk_builder_add_from_file( $ui-file, Any);
    die X::Gnome::Gtk3::Glade.new(:message("error adding ui")) if $error-code == 0;
  }

  else {
    $!builder .= new(:filename($ui-file));
  }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
multi method glade-add-gui ( Str:D :$ui-string! ) {

  if ?$!builder {
    my $error-code = $!builder.gtk_builder_add_from_string(
      $ui-string, $ui-string.chars, Any
    );
    die X::Gnome::Gtk3::Glade.new(:message("error adding ui")) if $error-code == 0;
  }

  else {
    $!builder .= new(:string($ui-string));
  }
}

#-------------------------------------------------------------------------------
method glade-add-css ( Str:D $css-file ) {

  return unless ?$css-file and $css-file.IO ~~ :r;

#$!css-provider.debug(:on);
  $!css-provider.gtk_css_provider_load_from_path( $css-file, Any);

  $!style-context.gtk_style_context_add_provider_for_screen(
    $!gdk-screen, $!css-provider, GTK_STYLE_PROVIDER_PRIORITY_USER
  );

  #my GtkCssProvider $css-provider = gtk_css_provider_get_named(
  #  'Kate', Any
  #);
}

#-------------------------------------------------------------------------------
method glade-run (
  Gnome::Gtk3::Glade::Engine::Test :$test-setup,
  #Str :$toplevel-id
) {

#  gtk_widget_show_all(gtk_builder_get_object( $!builder, $toplevel-id));

  if $test-setup.defined {

    # copy builder object to test object
    $test-setup.builder = $!builder;
    $test-setup.prepare-and-run-tests;
  }

  else {

note "Start loop";
    $!main.gtk_main();
  }
}

#-------------------------------------------------------------------------------
# Callback methods called from XML::Actions
#-------------------------------------------------------------------------------
#`{{}}
method object ( Array:D $parent-path, Str :$id is copy, Str :$class) {

#  note "Object $class, id '$id'";

#  return unless $class eq "GtkWindow";
#  $!top-level-object-id = $id unless ?$!top-level-object-id;
}


#-------------------------------------------------------------------------------
# signal element, e.g.
#   <signal name="clicked" handler="clear-text" swapped="no"/>
# possible attributes are: name, handler, object, after and swapped
method signal (
  Array:D $parent-path, Str:D :name($signal-name),
  Str:D :handler($handler-name),
  Str :$object, Str :$after, Str :$swapped
) {
  #TODO bring following code into XML::Actions
  my %object = $parent-path[*-2].attribs;
  my Str $id = %object<id>;
  my Str $class = %object<class>;
  $class ~~ s/^ ['Gtk' || 'Gdk'] //;
  my Str $class-name = 'Gnome::Gtk3::' ~ $class;
  my Bool $handler-found = False;

  for @$!engines -> $engine {
    my $args = ? $object
              ?? \($engine, $handler-name, $signal-name,
                   :target-widget-name($object)
                  )
              !! \($engine, $handler-name, $signal-name)
              ;

    if Gnome::Gtk3::{$class}:exists {
      my $gtk-widget = ::($class-name).new(:build-id($id));

      if $gtk-widget.register-signal(|$args) {
        $handler-found = True;
        last;
      }
    }

    else {
      try {
#note "require $class-name";
#      require ::('Gnome::Gtk3::');
        require ::($class-name);
#note "P2: ", Gnome::Gtk3::::.keys;

#note ::("Gnome::Gtk3::::$class").Bool;
        my $gtk-widget = ::($class-name).new(:build-id($id));
#  note "v3 gtk obj: ", $gtk-widget;

        if $gtk-widget.register-signal(|$args) {
          $handler-found = True;
          last;
        }

        CATCH {
#.note;
          default {
            note "Not able to load module: ", .message;
          }
        }
      }
    }
  }

  note "Handler $handler-name not defined in any engine" unless $handler-found;
}

#-------------------------------------------------------------------------------
# Private methods
#-------------------------------------------------------------------------------
#method !glade-parsing-error( $provider, $section, $error, $pointer ) {
#  note "Error";
#}

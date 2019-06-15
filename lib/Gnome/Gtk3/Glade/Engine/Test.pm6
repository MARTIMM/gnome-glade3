use v6;
use Test;
use NativeCall;

use Gnome::Gtk3::Glade::Engine;

use Gnome::GObject::Object;
use Gnome::Glib::Main;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::TextIter;

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::Glade::Engine::Test:auth<github:MARTIMM>;
also is Gnome::Gtk3::Glade::Engine;

# Must be set before by Gnome::Gtk3::Glade::Engine::Work.glade-run().
has Gnome::Gtk3::Builder $.builder is rw;

has Gnome::Gtk3::Main $!main;
#has Gnome::GObject::Object $!widget;
has Any $!test-value;
has Array $.steps;

#-------------------------------------------------------------------------------
# This method runs in a thread. Gui updates can be done using a context
method prepare-and-run-tests ( ) {

#$!builder.debug(:on);
  my Promise $p = $!builder.start-thread( self, 'run-tests', :new-context);

  # the main loop on the main thread
  $!main.gtk_main();

  # wait for the end and show result
  await $p;
  diag $p.result;
}

#-------------------------------------------------------------------------------
method run-tests ( ) {

  my Int $executed-tests = 0;

  if $!steps.elems {

    my Bool $ignore-wait = False;
    my $step-wait = 0.0;

    for @$!steps -> Pair $substep {
      if $substep.value() ~~ Block {
        diag "substep: $substep.key() => Code block";
      }

      elsif $substep.value() ~~ List {
        diag "substep: $substep.key() => ";
        for @($substep.value()) -> $v {
          diag "           $v.key() => $v.value()";
        }
      }

      else {
        diag "substep: $substep.key() => $substep.value()";
      }

      given $substep.key {
        when 'emit-signal' {
          my Hash $ss = %(|$substep.value);
          my Str $signal-name = $ss<signal-name> // 'clicked';
          my $widget = self!get-widget($ss);
          $widget.emit-by-name( $signal-name, $widget);
        }

        when 'get-text' {
          my Hash $ss = %(|$substep.value);
          my $widget = self!get-widget($ss);
          my Gnome::Gtk3::TextBuffer $buffer .= new(
            :widget($widget.get-buffer)
          );

          my Gnome::Gtk3::TextIter $start .= new;
          $buffer.get-start-iter($start);
          my Gnome::Gtk3::TextIter $end .= new;
          $buffer.get-end-iter($end);

          $!test-value = $buffer.get-text( $start, $end, 1);
        }

        when 'set-text' {
          my Hash $ss = %(|$substep.value);
          my Str $text = $ss<text>;
          my $widget = self!get-widget($ss);

          my $n-buffer = $widget.get-buffer;
          my Gnome::Gtk3::TextBuffer $buffer .= new(:widget($n-buffer));
          $buffer.set-text( $text, $text.chars);
          $widget.queue-draw;
        }

        when 'do-test' {
          next unless $substep.value ~~ Block;
          $executed-tests++;
          $substep.value()();
        }

        when 'get-main-level' {
          $!test-value = $!main.gtk-main-level;
        }

        when 'step-wait' {
          $step-wait = $substep.value();
        }

        when 'ignore-wait' {
          $ignore-wait = ?$substep.value();
        }

        when 'wait' {
          sleep $substep.value() unless $ignore-wait;
        }

        when 'debug' {
          Gnome::Gtk3::Button.new(:empty).debug(:on($substep.value()));
        }

        when 'finish' {
          last;
        }
      }

      sleep($step-wait)
        unless ( $substep.key eq 'wait' or $ignore-wait or $step-wait == 0.0 );

      # make sure things get displayed
      while $!main.gtk-events-pending() { $!main.iteration-do(False); }

      # Stop when loop is exited
      #last unless $!main.gtk-main-level();
    }

    # End the main loop
    $!main.gtk-main-quit() if $!main.gtk-main-level();
    while $!main.gtk-events-pending() { $!main.iteration-do(False); }
  }

  diag "Done testing";

  return "Nbr steps: {$!steps.elems // 0}, Nbr tests: $executed-tests";
}

#-------------------------------------------------------------------------------
method !get-widget ( Hash $opts --> Any ) {
  my Str:D $id = $opts<widget-id>;
  my Str:D $class = $opts<widget-class>;

  require ::($class);
  my $widget = ::($class).new(:build-id($id));
  is $widget.^name, $class, "Id '$id' of class $class found and initialized";

  $widget
}

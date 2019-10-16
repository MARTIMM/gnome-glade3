use v6;

use Test;
use Gnome::Gtk3::Glade;
use Gnome::Gtk3::Glade::Engine;
use Gnome::Gtk3::Glade::Engine::Test;

use Gnome::N::X;
#Gnome::N::debug(:on);


#use Gnome::Gtk3::Main;
#my Gnome::Gtk3::Main $m .= new;

#-------------------------------------------------------------------------------
my $dir = 'xt/x';
mkdir $dir unless $dir.IO ~~ :e;

my Str $file = "$dir/a.xml";
$file.IO.spurt(Q:q:to/EOXML/);
  <?xml version="1.0" encoding="UTF-8"?>
  <!-- Generated with glade 3.22.1 -->
  <interface>
    <requires lib="gtk+" version="3.10"/>
    <object class="GtkWindow" id="window">
      <property name="visible">True</property>
      <property name="can_focus">False</property>
      <property name="border_width">10</property>
      <property name="title">Grid</property>
      <signal name="destroy" handler="exit-program" swapped="no"/>
    </object>
  </interface>
  EOXML

#-------------------------------------------------------------------------------
class E is Gnome::Gtk3::Glade::Engine {

  submethod BUILD ( ) { }

  method exit-program ( --> 1 ) {
    self.glade-main-quit();
#    $m.gtk-main-quit;

    1
  }
}

#-------------------------------------------------------------------------------
class T does Gnome::Gtk3::Glade::Engine::Test {

  submethod BUILD ( ) {
    # Wait for start
    $!steps = [
      :ignore-wait,
      :step-wait(0.5),

#      :debug,
      :emit-signal(
        :widget-id<window>,
        :widget-class<Gnome::Gtk3::Window>,
        :signal-name<destroy>,
      ),
#      :!debug,

      :!ignore-wait,
      :wait(1.0),
      :get-main-level,
      :do-test( {
          # $!test-value set by get-main-level action
          is $!test-value, 0, 'loop level is 0';
        }
      ),

      # Stop tests
      :finish,
    ];
  }
}

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Glade $gui .= new;
my E $engine .= new;
my T $test .= new;

subtest 'ISA test', {
  isa-ok $gui, Gnome::Gtk3::Glade;
  isa-ok $engine, Gnome::Gtk3::Glade::Engine;
  isa-ok $test, T;
  does-ok $test, Gnome::Gtk3::Glade::Engine::Test;
}

#-------------------------------------------------------------------------------
#Gnome::N::debug(:on);
subtest 'Window create and destroy test', {
  $gui.add-gui-file($file);
  $gui.add-engine($engine);
  $gui.run(:test-setup($test));
}

#-------------------------------------------------------------------------------
done-testing;

unlink $file;
rmdir $dir;

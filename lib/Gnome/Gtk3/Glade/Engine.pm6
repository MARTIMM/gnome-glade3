use v6;
use NativeCall;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::TextIter;
use Gnome::Gtk3::TextBuffer;
use Gnome::Gtk3::TextView;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Glade::Engine:auth<github:MARTIMM>;

has Gnome::Gtk3::Main $!main;
has Gnome::Gtk3::TextBuffer $!text-buffer;
has Gnome::Gtk3::TextView $!text-view;

#-------------------------------------------------------------------------------
method glade-get-text ( Str:D $id --> Str ) {

  $!text-view .= new(:build-id($id));
  $!text-buffer .= new(:native-object($!text-view.get-buffer));

  my Gnome::Gtk3::TextIter $start = $!text-buffer.get-start-iter;
  my Gnome::Gtk3::TextIter $end = $!text-buffer.get-end-iter;

  $!text-buffer.get-text( $start, $end)
}

#-------------------------------------------------------------------------------
method glade-set-text ( Str:D $id, Str:D $text ) {

  $!text-view .= new(:build-id($id));
  $!text-buffer .= new(:native-object($!text-view.get-buffer));
  $!text-buffer.set-text($text);
}

#-------------------------------------------------------------------------------
method glade-add-text ( Str:D $id, Str:D $text is copy ) {

  $!text-view .= new(:build-id($id));
  $!text-buffer .= new(:native-object($!text-view.get-buffer));

  my Gnome::Gtk3::TextIter $start = $!text-buffer.get-start-iter;
  my Gnome::Gtk3::TextIter $end = $!text-buffer.get-end-iter;

  $text = $!text-buffer.get-text( $start, $end, 1) ~ $text;
  $!text-buffer.set-text($text);
}

#-------------------------------------------------------------------------------
# Get the text and clear text field. Returns the original text
method glade-clear-text ( Str:D $id --> Str ) {

  $!text-view .= new(:build-id($id));
  $!text-buffer .= new(:native-object($!text-view.get-buffer));

  my Gnome::Gtk3::TextIter $start = $!text-buffer.get-start-iter;
  my Gnome::Gtk3::TextIter $end = $!text-buffer.get-end-iter;

  my Str $text = $!text-buffer.get-text( $start, $end, 1);
  $!text-buffer.set-text("");

  $text
}

#-------------------------------------------------------------------------------
method glade-main-level ( ) {
  $!main.gtk-main-level;
}

#-------------------------------------------------------------------------------
method glade-main-quit ( ) {
  $!main.gtk-main-quit;
}

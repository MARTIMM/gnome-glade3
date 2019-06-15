use v6;

#-------------------------------------------------------------------------------
class X::Gnome::Gtk3::Glade is Exception {
  has $.message;

  submethod BUILD ( Str:D :$!message ) { }
}

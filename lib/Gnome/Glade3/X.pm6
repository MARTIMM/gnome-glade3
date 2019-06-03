use v6;

#-------------------------------------------------------------------------------
class X::Gnome::Glade3 is Exception {
  has $.message;

  submethod BUILD ( Str:D :$!message ) { }
}

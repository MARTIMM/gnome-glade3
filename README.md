![gtk logo][logo]

# Gnome::Gtk3::Glade - Accessing GTK+ using Glade
[![License](http://martimm.github.io/label/License-label.svg)](http://www.perlfoundation.org/artistic_license_2_0)

# Description
With the modules from package `Gnome::Gtk3` you can build a user interface and interact with it. This package however, is meant to load a user interface description saved by an external designer program. The program used is **glade** which saves an **XML** description of the made design.

The user must provide one or more classes containing methods to receive signals defined in the user interface design. Registration of signals will be done automatically.

Then only two lines of code (besides the loading of modules) is needed to let the user interface appear and enter the main loop.

# Synopsis
### User interface file
The first thing to do is designing a ui and save it. A part of the saved result is shown below. It shows the part of an exit button. Assume that this file is saved in **example.glade**.
```
<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated with glade 3.20.0 -->
<interface>
  <requires lib="gtk+" version="3.0"/>
  <object class="GtkWindow" id="window">
...
          <object class="GtkButton" id="quit">
            <property name="label">Quit</property>
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <property name="receives_default">False</property>
            <signal name="clicked" handler="quit-program"/>
          </object>
...
</interface>

```

### Class for signal handlers
Then write code to handle all signals which are defined by the user interface. These modules are called engines. You do not have to write every handler at once. You will be notified about a missing handler as soon as an event is fired for it.

Only the method to handle a click event from the quit button is shown below in the example. This example file is saved in **lib/MyEngine.pm6**.

```
use v6;
use Gnome::Gtk3::Glade;
use Gnome::Gtk3::Glade::Engine;

unit class MyEngine;
also is Gnome::Gtk3::Glade::Engine;

# $widget is the activated button after which this method is called. Methods
# are from Gnome::Gtk3::Button. See documentation in the Gnome::Gtk3 project.
method quit-program ( :$widget ) {

  note "Button label: ", $widget.get-label;
  note "Button name is by default button's class name: ", $widget.get-name;

  self.glade-main-quit();
}
  ...
```

### The main program
The rest is a piece of cake.
```
use v6;
use MyEngine;
use Gnome::Gtk3::Glade;

my Gnome::Gtk3::Glade $gui .= new;
$gui.add-gui-file("example.glade");
$gui.add-engine(MyEngine.new);
$gui.run;
```

# Documentation

* [Gnome::Gtk3::Glade][Gnome::Gtk3::Glade pdf]
* Gnome::Gtk3::Glade::Engine

## Miscellaneous
* [Release notes](https://github.com/MARTIMM/perl6-gnome-glade3/blob/master/doc/CHANGES.md)

# TODO

* [ ] What can we do with the Gnome::Gtk3::Glade object after it exits the main loop.
* [ ] Documentation.

# Versions of involved software

* Program is tested against the latest version of **perl6** on **rakudo** en **moarvm**.
* Used **glade** version is **>= 3.22**
* Generated user interface file is for **Gtk >= 3.10**

# Installation of Gnome::Gtk3::Glade

`zef install Gnome::Gtk3::Glade`


# Author

Name: **Marcel Timmerman**
Github account name: **MARTIMM**


<!---- [refs] ----------------------------------------------------------------->
[release]: https://github.com/MARTIMM/perl6-gnome-glade3/blob/master/doc/CHANGES.md
[logo]: https://github.com/MARTIMM/perl6-gnome-glade3/blob/master/doc/design-docs/gtk-logo-100.png

[//]: # (Pod documentation rendered with)
[//]: # (pod-render.pl6 --pdf --g=MARTIMM/perl6-gnome-glade3 lib)

[Gnome::Gtk3::Glade pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-glade3/blob/master/doc/Glade3.pdf

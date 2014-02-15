This module builds a debian light system inspired by forum member saintless on the murga-linux forum.

The structure of this module should demonstrate the use of some techniques to modify the debian light build.
folder hooks.chroot contains scripts and actions which will be executed in the chroot jail.
includes.chroot contains all the files which are added directly.

This moule has split the desktop (Window manager and ROX ) from the base system.
To build a CAT system, you should use the build.sh command with 2 options:

./build.sh CAT

which modules are loaded is defined in the /config/CAT file.







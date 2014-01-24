Debian-light-builder
====================

Build scripts for light Debian live systems. 
Input, ideas and light apps from other small distros (e.g. Puppy) are welcome.

Most of the code was written by Thierry Monteil for the project sage-debian-live
http://sagedebianlive.metelu.net/

Based on this code it should be possible to develope a Live CD version of sage (<700 MB).
Currently there is also interest in building small Debian Linux systems in the style of "Puppy Linux" on this List:
http://www.murga-linux.com/puppy/viewtopic.php?t=90660

Build your own small Debian Live system
===================================

It is possible to build your own Sage Debian Live. You should run Debian
wheezy. 
Derivatives whose version of live-build package is 3.x (like
Ubuntu>=12.04 or Debian sid) should work as well but are not tested.
Other Linuxes with Debian live build 3.x install should work too, but are not tested.

Download sources
----------------

Install git, go to a directory you want the sources to be cloned
to and type ::

    git clone https://github.com/emilwidmann/Debian-light-builder.git


Install dependencies
--------------------

To install required packages before your first build (you are assumed to be
sudoer), go to the source directory and type ::

    ./build.sh install


Consider using apt-cacher
-------------------------

To save bandwidth, it is advised to use the package apt-cacher ::

    sudo apt-get install apt-cacher


Customize your build 
--------------------

To customize your build, you can edit the ./config/default file and modify its
variables. All customizable variables are shown here, and some hints are given
along the file as comments. You can also overwrite the default variables by
using a custom ./config/customconfig file. This is a good way to do so that
your customizations will not be lost when you update the repository.
It is important to change the Paths in the scripts to match your setup. 
Please select the build directory outside the Debian-live-builder source tree.


Select modules
~~~~~~~~~~~~~~

All existing modules are selected by default. You can unselect some by
removing them from the MODULES variable. The modules are located in the
modules/ directory.


Deeper customizations
~~~~~~~~~~~~~~~~~~~~~

If you want to add some packages or files, or even add some hooks, you should
create your own module instead of modifying the existing ones (see the example
of ejcim2013 module), hence there won't be problems when those will be
updated.

If you think some of your customization could be of interest to someone else,
please do not hesitate to share them by contacting us (you can either send
your code on the mailing-lits or ask for an account to the mercurial server).


Launch the build
----------------

From the source directory, run ::

    ./build.sh

If you use a custom ./config/customconfig file to overwrite some default
variables, run ::

    ./build.sh customconfig

Note that config files can be stacked, for example you can customize a CD
config by running::

    ./build.sh cd customconfig
    
Right at the moment there are some simple setups with 3 small window managers present.
The Icewm window manager is the most eleborate one and has examples how to handel chroot.hooks and binary includes.

 ./build.sh cd icewm
 
 The result is an image or iso file which can be dd -ed to a stick or burned to a CD. See the next section how to directly install to hd.
  
 
 Test the image
 ----------------------
 The easiest way for testing is to install a virtual machine (e.g. apt-get install virtualbox) and test the iso there.
 
Another possibility is to make a frugal install to your hd. Mount the image, e.g. 
mkdir mpt
mount -o,loop binary-hybrid.iso mpt
cd mpt/live

copy the files vmlinuz, initrd.img and filesystem.squashfs to a /live folder on one of your hd partitions
Add a line in your bootloader like (example for grub legacy):

title Sage Debian Live
  root (hd0,2)
  kernel /live/vmlinuz boot=live config persistent quickreboot noprompt autologin
  initrd /live/initrd.img 

 
Debian-light-builder
====================

Build scripts for light Debian live systems. 
Input, ideas and light apps from other small distros (e.g. Puppy) are welcome.

Most of the code was written by Thierry Monteil for the project sage-debian-live
http://sagedebianlive.metelu.net/

Based on this code it should be possible to develope a Live CD version of sage (<700 MB).
Currently there is also interest in building small Debian Linux systems in the style of 
"Puppy Linux" on this list:
http://www.murga-linux.com/puppy/viewtopic.php?t=90660

Build your own small Debian Live system
===================================

It is possible to build your own Sage Debian Live. You should run Debian
wheezy. Derivatives whose version of live-build package is 3.x (like
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


Select modules
~~~~~~~~~~~~~~
./build.sh will use the /config/default file for configuration. 
With ./build.sh config1 config2 ... it is possible to add more configuration files 
which will overwrite the default values.



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

    ./build.sh install
    
This will install the live-build tools and apt-cacher (Choose to start
apt-cahcer as daemon at the prompt). If you are running apt-cacher from 
a live system und you are low on RAM, you should change the cache_dir in
/etc/apt-cacher/apt-cacher.conf to be somewhere on a mounted drive.

To build module CAT run:

    ./build.sh CAT

CAT is the most refined module. At the moment there are some simple
additional setups with 2 small window managers (JWM, openbox). 
The CAT module is the most eleborate one and 
has examples how to handle chroot.hooks and binary includes.
The result is an image or iso file which can be dd -ed to a stick or burned 
to a CD. See the next section how to directly install to hd.
  
 
Test the image
----------------------
The easiest way for testing is to install a virtual machine.
(e.g. apt-get install virtualbox) Attach the iso file in your $BUILD directory
and test the iso in the VM.
 
Another possibility is to make a frugal install to your hd. Mount the image, e.g. 
mkdir mpt
mount -o,loop binary-hybrid.iso mpt
cd mpt/live

copy the files vmlinuz, initrd.img and filesystem.squashfs to a /live folder on one of your hd partitions
Add a line in your bootloader like (example for grub legacy):

title Debian-live-test
  root (hd0,2)
  kernel /live/vmlinuz boot=live config persistent quickreboot noprompt autologin
  initrd /live/initrd.img 

It is possible to have several versions on the same partition. In that case the 
live-media and live-media-path boot parameters are useful.

title Test Partition
  root (hd0,5)
  kernel /live/vmlinuz boot=live  live-media=/dev/sda6 config quickreboot noprompt autologin
  initrd /live/initrd.img 

Reboot your computer.

contact: emil.widmann!!gmail.cXX

 

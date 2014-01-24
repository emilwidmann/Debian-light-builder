#!/bin/bash

#
#*****************************************************************************
#   Copyright (C) 2012 Thierry Monteil <sage-debian-live!lma.metelu.net>
#
#  Distributed under the terms of the GNU General Public License (GPL)
#  as published by the Free Software Foundation; either version 2 of
#  the License, or (at your option) any later version.
#                  http://www.gnu.org/licenses/
#*****************************************************************************
#
# This install script adds various useful software.


## laptop
add_packages "laptop" "task-laptop"

## editors
add_packages "editors" "vim emacs scite texmaker lyx"
add_packages "editors" "gedit gedit-plugins gedit-latex-plugin"
add_packages "editors" "texworks texworks-scripting-python"
add_packages "editors" "gedit-source-code-browser-plugin"
add_packages "editors" "gobby"

add_packages "textconverter" "antiword catdoc unrtf untex"

## mainstream
add_packages "stuff" "gimp inkscape less scribus"
add_packages "stuff" "xul-ext-adblock-plus gnupg lsof htop iotop"
add_packages "stuff" "lshw usbutils pciutils screen bash-completion"
add_packages "pdf" "evince xpdf okular pdftk diffpdf"
add_packages "video" "vlc mplayer2 ffmpeg libav-tools winff"
add_packages "audio" "ripperx flac sox vorbis-tools cdparanoia"
### a bit too big
# add_packages "stuff" "libreoffice-l10n-*"
add_packages "network" "openssh-client filezilla curl elinks"
add_packages "network" "net-tools wireshark iftop jnettop"
add_packages "network" "whois nmap"
add_packages "noflash" "nomnom get-flash-videos quvi clive cclive"
# add_packages "wikipedia" "kiwix"
## minitube not in wheezy
## add_packages "noflash" "minitube"
## irssi-plugin-otr removed from wheezy
# add_packages "chat" "irssi irssi-plugin-otr irssi-plugin-xmpp irssi-scripts"
add_packages "chat" "irssi irssi-plugin-xmpp irssi-scripts"
add_packages "chat" "pidgin pidgin-otr pidgin-openpgp pidgin-latex"
add_packages "chat" "pidgin-privacy-please pidgin-encryption"
add_packages "burn" "xorriso cdck wodim dvd+rw-tools genisoimage"

## devel
add_packages "programming" "build-essential python ocaml ghc"
## add_packages "programming-full-libs" "ocaml-batteries-included haskell-platform"
add_packages "dvcs" "mercurial git mercurial-git darcs bzr"


## filesystems
add_packages "filesystems" "hfsplus hfsprogs xfsprogs xfsdump"
add_packages "filesystems" "btrfs-tools"
add_packages "filesystems" "reiser4progs reiserfsprogs"
add_packages "filesystems" "dosfstools ntfs-3g exfat-fuse exfat-utils"
add_packages "filesystems" "cryptsetup cryptmount encfs ecryptfs-utils"
add_packages "filesystems" "pmount fstransform kpartx dmsetup dmraid"
add_packages "filesystems" "nfs-common"
add_packages "filesystems" "bindfs fuse-posixovl"
add_packages "filesystems" "squashfs-tools"
add_packages "filesystems" "unionfs-fuse aufs-tools mhddfs"
add_packages "filesystems" "lvm2 system-config-lvm"

add_packages "rescue" "scalpel gddrescue dump foremost magicrescue gpart"
add_packages "rescue" "sleuthkit autopsy testdisk wipe parted gparted"
add_packages "rescue" "smartmontools guymager"
add_packages "backup" "rsync duplicity partimage backup-manager"
add_packages "backup" "rdiff-backup rdiff-backup"
add_packages "admin" "makepasswd"


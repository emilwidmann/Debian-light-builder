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
# This is the install script of the openbox module. It is supposed to be used
# instead of the xfce4 modules for light builds.

add_packages "icewm" "nodm xserver-xorg icewm menu rox-filer xfe iceweasel"
add_packages "desktop" "xterm sudo user-setup eject alsa-base alsa-utils"

# hooks which will be executed in the chroot system
cp "${BASE_DIR}/modules/icewm/hooks.chroot/*" "${BUILD_DIR}/config/hooks/"

# files to include in the chroot system (includes.chroot):
# /usr/share/icewm/.. themes and configuration files
# /opt.. Programms, apps and configurations not in Debian
cp -r "${BASE_DIR}/modules/icewm/includes.chroot" "${BUILD_DIR}/config/"


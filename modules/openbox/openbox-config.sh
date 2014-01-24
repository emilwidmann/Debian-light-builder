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

add_packages "openbox" "nodm xserver-xorg openbox menu wicd rox-filer iceweasel"
add_packages "desktop" "xterm sudo user-setup less eject alsa-base alsa-utils"

add_packages "laptop" "acpid acpi acpi-support pcmciautils bluetooth pm-utils"

cp "/usr/share/doc/live-build/examples/hooks/stripped.chroot" "${BUILD_DIR}/config/hooks/"

cp "${BASE_DIR}/modules/openbox/nodm-hooks.chroot" "${BUILD_DIR}/config/hooks/"


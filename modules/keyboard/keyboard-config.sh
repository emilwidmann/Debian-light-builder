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
# This is the install script of the keyboard switcher module. It allows the
# user to change her desktop keyboard

add_packages "keyboard" "zenity x11-xkb-utils"
add_file keyboard.sh /keyboard/ /opt/bin/ 755
add_file keyboard-icon.svg /keyboard/ /usr/share/pixmaps
add_file keyboard.desktop /keyboard/ /usr/share/applications
add_file keyboard.desktop /keyboard/ /ext/skel/.config
add_file keyboard.desktop /keyboard/ /root/.config


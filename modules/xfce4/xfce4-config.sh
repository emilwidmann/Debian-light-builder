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
# This is the install script of the xfce4 module.


## Packages useful for using sage
add_packages "xfce4" "task-xfce-desktop"


## Thunar as default file manager (avoid annoying question at first startup)
add_file helpers.rc /xfce4/ /etc/skel/.config/xfce4/ 644


## No need to uncheck the checkbox "Use system defaults" to be able to modify keyboard settings
add_file keyboard-layout.xml /xfce4/ /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/ 644


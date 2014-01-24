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
# This is the config script of the keepinstall module. This module allows the
# user to install some packages in a way that they will remain available after
# rebooting.

add_packages "keepinstall" "mksquashfs"

add_file keepinstall.sh /keepinstall/ /opt/keepinstall/ 755

cp "${BASE_DIR}/modules/keepinstall/keepinstall-hooks.chroot" "${BUILD_DIR}/config/hooks/"


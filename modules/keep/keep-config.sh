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
# This is the config script of the keep module. This module allows the user to
# keep system changes (on a specified directory, after install update or
# upgrade) in a way that they will remain available after rebooting.

add_packages "keep" "squashfs-tools bash-completion"

add_file keep.sh /keep/ /opt/keep/ 755

add_file keep.completion /keep/ /opt/keep/ 644

add_file loop.conf /keep/ /etc/modprobe.d/ 644

cp "${BASE_DIR}/modules/keep/keep-hooks.chroot" "${BUILD_DIR}/config/hooks/"


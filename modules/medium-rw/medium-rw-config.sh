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
# This is the config script of the persistence module. The persistence module
# allows straightforward persistence of the homedir for the debian-live system.

add_packages "remount-rw" "fuse-posixovl"
add_file 0024-medium-rw /medium-rw/ /lib/live/config/ 0755


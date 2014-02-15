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
# This modules enables wireless.


add_packages "wireless" "wireless-tools wpasupplicant firmware-linux-free"
add_packages "wireless" "ndisgtk ndiswrapper-utils-1.9"

if [ "${NON_FREE_WIRELESS}" = "1" ]
then
    add_packages "wireless" "firmware-linux-nonfree"
    add_packages "wireless" "atmel-firmware firmware-atheros"
    add_packages "wireless" "firmware-bnx2 firmware-bnx2x"
    add_packages "wireless" "firmware-brcm80211 firmware-intelwimax"
    add_packages "wireless" "firmware-ipw2x00 firmware-iwlwifi"
    add_packages "wireless" "firmware-libertas"
    add_packages "wireless" "firmware-ralink firmware-realtek"
    add_packages "wireless" "libertas-firmware zd1211-firmware"
    add_packages "wireless" "firmware-b43legacy-installer firmware-b43-installer"
fi

if [ "${NON_FREE_WIRELESS}" = "2" ]
then
   add_packages "wireless" "firmware-b43legacy-installer firmware-b43-installer"
fi

# hooks which will be executed in the chroot system
cp -r "${BASE_DIR}/modules/wireless2/hooks" "${BUILD_DIR}/config/"

# files to include in the chroot system (includes.chroot):
cp -r "${BASE_DIR}/modules/wireless2/includes.chroot" "${BUILD_DIR}/config/"

# packages to include in the chroot system (packages.chroot):
cp -r "${BASE_DIR}/modules/wireless2/packages.chroot" "${BUILD_DIR}/config/"
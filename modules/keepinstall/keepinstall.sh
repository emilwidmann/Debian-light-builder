#!/usr/bin/sudo /bin/bash

#*****************************************************************************
#   Copyright (C) 2012 Thierry Monteil <sage-debian-live!lma.metelu.net>
#
#  Distributed under the terms of the GNU General Public License (GPL)
#  as published by the Free Software Foundation; either version 2 of
#  the License, or (at your option) any later version.
#                  http://www.gnu.org/licenses/
#*****************************************************************************
#
# This script allows the user to install some packages in a way that they will
# remain available after rebooting.


set -e

# Variables you may change
OVERLAY_DIR="/lib/live/mount/overlay" 
RELATIVE_KEEP_DIRS="./bin ./etc ./lib ./sbin ./usr ./var/lib"
RELATIVE_EXCLUDE_DIRS="./lib/live"
SQUASHFS_MOUNT_POINT='/lib/live/mount/medium'
SQUASHFS_DIR="/lib/live/mount/medium/live/"
SQUASHFS_PREFIX='z-'
SQUASHFS_SUFFIX='-package.squashfs'
DEFAULT_SQUASHFS_NAME='filesystem.squashfs'
MODULE_NAME='filesystem.module'
CONTENTS_NAME='filesystem.module.contents'
TEST_NAME="keepinstall_test_${$}"
TIME_FILE="/keepinstall_timer_${$}"
BUILD_DIR="/keepinstall_${$}"
WARNING_MESSAGE='DO NOT DO PLAY WITH YOUR COMPUTER UNTIL THIS IS FINISHED !'

# Internal variables
DATE="$(date +%Y-%m-%dT%Hh%Mm%Ss)"
SQUASHFS_NAME="${SQUASHFS_PREFIX}${DATE}${SQUASHFS_SUFFIX}"
# EXCLUDE_PATTERNS is currenty not working, hence disabled
EXCLUDE_PATTERNS="$(for i in ${RELATIVE_EXCLUDE_DIRS} ; \
                    do echo ! -path \"$i/*\" ; done)"
EXCLUDE_PATTERNS=''
# We also need to keep instaled dependencies.
ALL_PACKAGES="$(apt-get install -s "${@}" | grep '^Inst ' | \
                sed 's/^Inst //g' | sed 's/ .*//g' | tr '\n' ' ')"


# Let us start
echo ${WARNING_MESSAGE}


# Let the squashfs hosting the medium writable
if ( ! $(sudo touch ${SQUASHFS_MOUNT_POINT}/${TEST_NAME}) ) ; 
then
    mount -o remount,rw ${SQUASHFS_MOUNT_POINT}
else
    rm "${SQUASHFS_MOUNT_POINT}/${TEST_NAME}"
fi


# Get access to the overlay directory
touch "${TIME_FILE}"
while [ ! -f "${OVERLAY_DIR}/${TIME_FILE}" ] ; do
    umount ${OVERLAY_DIR}
done


# Install the required packages
touch "${TIME_FILE}"
apt-get install "${@}"


# Add newly created files or symlinks
mkdir -p "${BUILD_DIR}"
cd "${OVERLAY_DIR}"
find ${RELATIVE_KEEP_DIRS} ${EXCLUDE_PATTERNS} -type l -newer "${TIME_FILE}" \
    -exec cp --archive --parent '{}' "${BUILD_DIR}" \; || true
find ${RELATIVE_KEEP_DIRS} ${EXCLUDE_PATTERNS} -type f -newer "${TIME_FILE}" \
    -exec cp --archive --parent '{}' "${BUILD_DIR}" \; || true


# Add files that belong to the installed deb packages
for PACKAGE in ${ALL_PACKAGES} ; do
    for FILE in $(for i in $(dpkg -L "${PACKAGE}") ; do \
                if [ -f "${i}" ] ; then echo "${i}" ; fi ; done) ; do
        cp --archive --parent "${FILE}" "${BUILD_DIR}"
    done
done


# Build the image
mksquashfs "${BUILD_DIR}" "${SQUASHFS_DIR}/${SQUASHFS_NAME}"


# Update list of squashfs file to load at startup
if [ ! -f "${SQUASHFS_DIR}/${MODULE_NAME}" ] ; then
    echo "${DEFAULT_SQUASHFS_NAME}" > "${SQUASHFS_DIR}/${MODULE_NAME}"
fi
echo "${SQUASHFS_NAME}" >> "${SQUASHFS_DIR}/${MODULE_NAME}"
echo "${SQUASHFS_NAME} # ${ALL_PACKAGES}" >> "${SQUASHFS_DIR}/${CONTENTS_NAME}"


# Cleanup
rm -rf "${BUILD_DIR}"
rm -f "${TIME_FILE}"
sync

exit 0


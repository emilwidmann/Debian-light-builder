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
# This script allows the user to keep some system modifications (specific
# directory, install, update, upgrade) in a way that they will remain available
# after rebooting.


set -e

# Variables you may change
OVERLAY_DIR="/lib/live/mount/overlay"
RELATIVE_KEEP_DIRS="./bin ./etc ./lib ./sbin ./usr ./var/lib"
RELATIVE_EXCLUDE_DIRS="./lib/live"
SQUASHFS_MOUNT_POINT='/lib/live/mount/medium'
SQUASHFS_DIR="/lib/live/mount/medium/live/"
SQUASHFS_PREFIX='z-'
SQUASHFS_SUFFIX='.squashfs'
DEFAULT_SQUASHFS_NAME='filesystem.squashfs'
MODULE_NAME='filesystem.module'
CONTENTS_NAME='filesystem.module.contents'
TEST_NAME="keepinstall_test_${$}"
TIME_FILE="/keepinstall_timer_${$}" # inside the aufs
BUILD_DIR="/run/shm/keepinstall_${$}" # outside the aufs to also copy .wh files
WARNING_MESSAGE='DO NOT DO PLAY WITH YOUR COMPUTER UNTIL THIS IS FINISHED !'

# Internal variables
DATE="$(date +%Y-%m-%dT%Hh%Mm%Ss)"
SQUASHFS_NAME="${SQUASHFS_PREFIX}${DATE}-${1}${SQUASHFS_SUFFIX}"
# EXCLUDE_PATTERNS is currenty not working, hence disabled
EXCLUDE_PATTERNS="$(for i in ${RELATIVE_EXCLUDE_DIRS} ; \
                    do echo ! -path \"$i/*\" ; done)"
EXCLUDE_PATTERNS=''

# Let us start
echo ${WARNING_MESSAGE}


# Let the squashfs hosting the medium writable
if ( ! $(sudo touch ${SQUASHFS_MOUNT_POINT}/${TEST_NAME}) ) ; then
    mount -o remount,rw ${SQUASHFS_MOUNT_POINT}
else
    rm "${SQUASHFS_MOUNT_POINT}/${TEST_NAME}"
fi


# Get access to the overlay directory
touch "${TIME_FILE}"
while [ ! -f "${OVERLAY_DIR}/${TIME_FILE}" ] ; do
    umount ${OVERLAY_DIR}
done


# Specific actions and tuning
case "${1}" in

    (install)
        shift ;
        # We also need to keep instaled dependencies.
        ALL_PACKAGES="$(apt-get install -s "${@}" | grep '^Inst ' | \
                sed 's/^Inst //g' | sed 's/ .*//g' | tr '\n' ' ')" ;
        NEWER_PATTERN="-newer ${TIME_FILE}" ;
        touch "${TIME_FILE}" ;
        apt-get install "${@}" ;
        INFO="${ALL_PACKAGES}" ;
        ;;

    (update)
        shift ;
        RELATIVE_KEEP_DIRS+='./var/lib/apt/' ;
        EXCLUDE_PATTERNS='' ;
        NEWER_PATTERN="" ;
        ALL_PACKAGES='' ;
        INFO='update' ;
        apt-get update ;
        ;;

    (upgrade)
        shift ;
        NEWER_PATTERN="-newer ${TIME_FILE}" ;
        touch "${TIME_FILE}" ;
        # We also need to keep instaled dependencies.
        ALL_PACKAGES="$(apt-get upgrade -s "${@}" | grep '^Inst ' | \
                sed 's/^Inst //g' | sed 's/ .*//g' | tr '\n' ' ')" ;
        INFO="${ALL_PACKAGES}" ;
        apt-get upgrade ;
        ;;

    (dir)
        shift ;
        RELATIVE_KEEP_DIRS=$(for i in ${@} ; do echo '.'$(readlink -f $i) ; done) ;
        EXCLUDE_PATTERNS='' ;
        NEWER_PATTERN='' ;
        ALL_PACKAGES='' ;
        INFO="${RELATIVE_KEEP_DIRS}" ;
        ;;

    (merge)
        shift ;
        echo "Not implemented yet" ;
        exit 0 ;
        ;;

    (*)
        shift ;
        cat <<  EOF
        Usage :
            keep dir directory1 [directory2 directory3 ...]
            keep help
            keep merge
            keep install package1 [package2 package3 ...]
            keep update
            keep upgrade
EOF
        exit 0 ;
        ;;

esac


# Add newly created files or symlinks
mkdir -p "${BUILD_DIR}"
cd "${OVERLAY_DIR}"
find ${RELATIVE_KEEP_DIRS} ${EXCLUDE_PATTERNS} -type l ${NEWER_PATTERN} \
    -exec cp --no-dereference --preserve=all --parent '{}' "${BUILD_DIR}" \; || true
find ${RELATIVE_KEEP_DIRS} ${EXCLUDE_PATTERNS} -type f ${NEWER_PATTERN} \
    -exec cp --no-dereference --preserve=all --parent '{}' "${BUILD_DIR}" \; || true


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
echo "${SQUASHFS_NAME} # ${INFO}" >> "${SQUASHFS_DIR}/${CONTENTS_NAME}"


# Cleanup
rm -rf "${BUILD_DIR}"
rm -f "${TIME_FILE}"
sync

exit 0


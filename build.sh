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
# This script builds a Debian Live with clone capabilities, language switcher,
# straightforward persistence, mathematics software and other goodies. It needs
# Debian wheezy (the lb_config options are very volatile).


## First initialisation: install needed packages on your machine.

BASE_DIR="$(pwd)"
LOCAL_REPO=${BASE_DIR}/repo

if [ "x${1}" = "xinstall" ] ;
then
    sudo apt-get update
    sudo apt-get install live-build live-boot live-config syslinux kpartx apt-cacher
    exit 0
 
fi

cd ${BASE_DIR}

add_packages()
{
   PACKAGES_LIST_NAME="${1}"
   shift
   PACKAGES="${@}"
   echo "${PACKAGES}" >> \
        "${BUILD_DIR}"/config/package-lists/"${PACKAGES_LIST_NAME}".list.chroot
}

## parameters: filename relative-source-dir relative-dest-dir chmod
add_file () {
    mkdir -p "${BUILD_DIR}/config/includes.chroot/${3}"
    cp "${BASE_DIR}/modules/${2}/${1}" "${BUILD_DIR}/config/includes.chroot/${3}"
    chmod "${4}" "${BUILD_DIR}/config/includes.chroot/${3}/${1}"
}

## parameters: name [w/o .desktop -icon.svg] relative-source-dir rel-dest-dir
add_launcher () {
    add_file "${1}.desktop" "${2}" "${3}" 644
    add_file "${1}.desktop" "${2}" "/etc/skel/Desktop/" 644
    add_file "${1}.desktop" "${2}" "/etc/skel/.local/share/applications" 644
    add_file "${1}-icon.svg" "${2}" "${3}" 644
## symlink of a .desktop file on the Desktop adds an arrow on the icon
#    mkdir -p "${BUILD_DIR}/config/includes.chroot/etc/skel/Desktop/"
#    cd "${BUILD_DIR}/config/includes.chroot/etc/skel/Desktop/"
#    ln -s "/${3}/${1}.desktop"
#    cd "${BUILD_DIR}"
}


### Configuration loading
for config in default "${@}" ; do
    . "${BASE_DIR}/config/${config}"
done


### Prepare the build directory ###
sudo rm -rf "${BUILD_DIR}"
sudo mkdir -p "${BUILD_DIR}"
sudo chown "${USER}":"${USER}" "${BUILD_DIR}"
cd "${BUILD_DIR}"


ARCHIVES_AREAS='main'
if [ "${NON_FREE_WIRELESS}" != "0" ]
then
    ARCHIVES_AREAS='main contrib non-free'
fi


### BASIC CONFIGURATION
cd "${BUILD_DIR}"
lb clean
lb config --binary-images "${IMAGE}" \
    --distribution "${DISTRO}" \
    --archive-areas "${ARCHIVES_AREAS}" \
    --mode "debian" \
    --apt-recommends "${RECOMMENDS}" \
    --apt-indices "${INDICES}"\
    --bootappend-live "boot=live config locales=${BOOT_LOCALE} keyboard-layouts=${BOOT_KEYBOARD}" \
    --architectures "${ARCHITECTURE}" \
    --linux-flavours "${LINUX_FLAVOURS}" \
    --compression "${COMPRESS}"\
    --parent-mirror-bootstrap "${LOCAL_REPOSITORY}" \
    --parent-mirror-chroot "${LOCAL_REPOSITORY}" \
    --parent-mirror-binary "${BINARY_REPOSITORY}" \
    --mirror-bootstrap "${LOCAL_REPOSITORY}" \
    --mirror-chroot "${LOCAL_REPOSITORY}" \
    --mirror-binary "${BINARY_REPOSITORY}" \
    --checksums none \
    --cache false

### installer temporarly disabled
#    --debian-installer live --debian-installer-gui true
#
# add_packages "installer" "debian-installer-launcher gparted"



### Modules installation

for module in ${MODULES} ; do
    . "${BASE_DIR}/modules/${module}/${module}-config.sh"
done



### BUILD
cd "${BUILD_DIR}"
sudo lb build |& tee "${BUILD_DIR}/build.log"


### Post-processing (TODO : put the maximum as hook scripts) ###

if [ "x${IMAGE}" = "xhdd" ] ; then
    # sudo cp "${BASE_DIR}/syslinux/live.cfg" \
    #    "${BUILD_DIR}/binary/syslinux/live.cfg"
    # sudo mv "${BUILD_DIR}/binary/syslinux" "${BUILD_DIR}/binary/live"
    # sudo mv "${BUILD_DIR}/binary/doc" "${BUILD_DIR}/binary/live"
    sudo rm -rf "${BUILD_DIR}/binary/.disk"
    # sudo rm "${BUILD_DIR}/binary/SHA256SUMS"
    # sudo rm "${BUILD_DIR}/binary/md5sum.txt"

    sudo touch "${BUILD_DIR}/binary/live/files.txt"
    sudo touch "${BUILD_DIR}/binary/live/SHA256SUMS"
    cd "${BUILD_DIR}/binary"
    find -type d | sudo tee "${BUILD_DIR}/binary/live/directories.txt" > /dev/null
    find -type f | grep -v ldlinux.sys | sudo tee "${BUILD_DIR}/binary/live/files.txt" > /dev/null
    sudo rm "${BUILD_DIR}/binary/live/SHA256SUMS"
    cd "${BUILD_DIR}/binary"
    sudo find ./live -type f -print0 | sudo xargs -0 sha256sum | sudo tee -a "${BUILD_DIR}/binary/live/SHA256SUMS"
    echo "${LONG_NAME} - ${DISTRO} - ${LINUX_FLAVOURS}" | sudo tee "${BUILD_DIR}/binary/live/genealogy.txt"
    sudo mkdir "${BUILD_DIR}/binary/share"


    ## building the image
    sudo rm "${BUILD_DIR}/binary.img"
    sudo mkdir "${BUILD_DIR}/img"
    cd "${BUILD_DIR}/img"
    sudo dd if=/dev/zero of="${IMG_NAME}" bs=1M count=3600
    FREE_LOOP=$(sudo losetup -f)
    sudo losetup "${FREE_LOOP}" "${IMG_NAME}"
    sudo sfdisk "${FREE_LOOP}" << EOF
    0,,b,*
EOF
    sudo losetup -d "${FREE_LOOP}"
    sudo dd if=/usr/lib/syslinux/mbr.bin conv=notrunc bs=440 count=1 of=${IMG_NAME}

    PART_LOOP="/dev/mapper/$(sudo kpartx -av ${IMG_NAME} | sed 's/^add map //g' | sed 's/ .*//g')"
    sudo dd if=/dev/zero of="${PART_LOOP}" bs=512 count=1
    sudo mkfs.vfat -F 32 "${PART_LOOP}"
    sudo mkdir mount_point
    sudo mount "${PART_LOOP}" mount_point
    sudo cp -a ../binary/* mount_point/
    sync
    sudo umount mount_point
    sudo syslinux -d /live/syslinux "${PART_LOOP}"
    sudo kpartx -d "${IMG_NAME}"
fi

# Fix 02-02-14 : seems like a bug, keyboard is reset with every live-builder call
# so set it back to original - ew 
setxkbmap de



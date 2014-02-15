#!/bin/bash

#
#*****************************************************************************
#   Copyright (C) 2014 Emil Widmann <emil.widmann!gmail.comt> GPL 2
#*****************************************************************************

add_packages "desktop" "nodm sudo user-setup xfe xterm eject alsa-base alsa-utils"

add_packages "internet" "iceweasel"
add_packages "tools" "synaptic gparted grub2 rsync openssh-client mtpaint"
add_packages "burn" "xorriso cdck dvd+rw-tools genisoimage"

add_packages "filesystems" "hfsplus hfsprogs xfsprogs xfsdump btrfs-tools reiser4progs reiserfsprogs"
add_packages "filesystems" "dosfstools ntfs-3g exfat-fuse exfat-utils nfs-common bindfs fuse-posixovl"
add_packages "squash" "squashfs-tools"

# hooks which will be executed in the chroot system
cp -r "${BASE_DIR}/modules/CAT/hooks" "${BUILD_DIR}/config/"

# files to include in the chroot system (includes.chroot):
cp -r "${BASE_DIR}/modules/CAT/includes.chroot" "${BUILD_DIR}/config/"

# install non original deb packages which are not in repo
cp -r "${BASE_DIR}/modules/CAT/packages.chroot" "${BUILD_DIR}/config/"

# install binar_local-hooks which will run outside of chroot to do last customisation - Carefull!
# cp -r "${BASE_DIR}/modules/CAT/binary_local-hooks" "${BUILD_DIR}/config/"


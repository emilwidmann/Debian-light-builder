#!/bin/bash
#
#*****************************************************************************
#   Copyright (C) 2014 Emil Widmann <emil.widmann!gmail.comt> GPL 2
#*****************************************************************************

add_packages "desktop" "nodm sudo user-setup xfe xterm eject alsa-base alsa-utils"
add_packages "internet" "iceweasel"
add_packages "filesystems" "ntfs-3g"
add_packages "squash" "squashfs-tools"

# hooks which will be executed in the chroot system
cp -r "${BASE_DIR}/modules/CAT/hooks" "${BUILD_DIR}/config/"

# files to include in the chroot system (includes.chroot):
cp -r "${BASE_DIR}/modules/CAT/includes.chroot" "${BUILD_DIR}/config/"

# install non original deb packages which are not in repo
cp -r "${BASE_DIR}/modules/CAT/packages.chroot" "${BUILD_DIR}/config/"

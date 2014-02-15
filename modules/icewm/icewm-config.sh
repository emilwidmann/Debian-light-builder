#!/bin/bash

#*****************************************************************************
#   Copyright (C) 2014 Emil Widmann - GPL 2.0 <emil.widmann!!gmail.com
#*****************************************************************************

add_packages "icewm" "xserver-xorg icewm menu rox-filer volumeicon-alsa"

# hooks which will be executed in the chroot system
cp -r "${BASE_DIR}/modules/icewm/hooks" "${BUILD_DIR}/config/"

# files to include in the chroot system (includes.chroot):
cp -r "${BASE_DIR}/modules/icewm/includes.chroot" "${BUILD_DIR}/config/"

# packages to include in the chroot system (packages.chroot):
# this didn't work for me, so I use local apt repository (setup in ./build.sh install)
cp -r "${BASE_DIR}/modules/icewm/packages.chroot" "${BUILD_DIR}/config/"

# add local repo to list of valid repos in chroot:
#echo "deb http://localhost/${BASE_DIR}/repo ./" >  ${BUILD_DIR}/config/archives/local-repository.list.chroot

# copy public key to the chroot config directory
#cp "${BASE_DIR}/repo/*.gpg" "${BUILD_DIR}/config/apt"
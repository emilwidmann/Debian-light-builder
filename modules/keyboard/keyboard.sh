#!/bin/bash

# A simple keyboard switcher. Works on Debian.

#*****************************************************************************
#   Copyright (C) 2012 Thierry Monteil <sage-debian-live!lma.metelu.net>
#
#  Distributed under the terms of the GNU General Public License (GPL)
#  as published by the Free Software Foundation; either version 2 of
#  the License, or (at your option) any later version.
#                  http://www.gnu.org/licenses/
#*****************************************************************************

SYMBOLS_DIR='/usr/share/X11/xkb/symbols/'

CURRENT_LAYOUT="$(setxkbmap -print|grep xkb_symbols|cut -d+ -f2)"
ALL_LAYOUTS="$(for i in $(ls ${SYMBOLS_DIR}) ; do if [ -f ${SYMBOLS_DIR}/$i ] ; then echo $i ; fi ; done)"
LAYOUTS="$(for i in ${ALL_LAYOUTS} ; do if ( echo ${i} | egrep -v "...." > /dev/null) ; then echo $i ; fi ; done)"

CHOSEN_LAYOUT=$(zenity --list \
    --title="Choose your keyboard layout" \
    --column="Layout (current layout is ${CURRENT_LAYOUT})" \
    ${LAYOUTS})

if [ $? -ne 0 ] ; then exit 1 ; fi

touch "${HOME}/.xsessionrc"
sed -i.old '/^setxkbmap/d' "${HOME}/.xsessionrc"
echo "setxkbmap -layout ${CHOSEN_LAYOUT}" >> "${HOME}/.xsessionrc"

setxkbmap -layout ${CHOSEN_LAYOUT}

exit 0


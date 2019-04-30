#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Software
# 
# + Update the Zynthian Software from repositories.
# + Install/update extra packages (recipes).
# + Reconfigure system.
# + Reboot when needed.
# 
# Copyright (C) 2015-2017 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# ****************************************************************************

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

#------------------------------------------------------------------------------
# Reboot flag-file
#------------------------------------------------------------------------------

export REBOOT_FLAGFILE="/tmp/zynthian_reboot"
rm -f $REBOOT_FLAGFILE

#------------------------------------------------------------------------------
# Update Date/Time from network ...
#------------------------------------------------------------------------------

echo "Updating system date/time from network ..."
htpdate -s www.pool.ntp.org wikipedia.org google.com

#------------------------------------------------------------------------------
# Update from repositories ...
#------------------------------------------------------------------------------

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_SYS_DIR
git checkout .
git pull

cd ./scripts
./update_zynthian_recipes.sh
./update_zynthian_data.sh
./update_zynthian_sys.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git checkout .
git pull | grep -q -v 'Already up-to-date.' && ui_changed=1
./build.sh

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_UI_DIR
git checkout .
git pull | grep -q -v 'Already up-to-date.' && ui_changed=1
rm -f zynthian_gui_config_new.py
if [ -d "jackpeak" ]; then
	./jackpeak/build.sh
fi

echo "Updating zynthian-webconf ..."
cd $ZYNTHIAN_DIR/zynthian-webconf
git checkout .
git pull | grep -q -v 'Already up-to-date.' && webconf_changed=1


if [ -f $REBOOT_FLAGFILE ]; then
	rm -f $REBOOT_FLAGFILE
	reboot
fi

if [[ "$ui_changed" -eq 1 ]]; then
	systemctl restart zynthian
fi

if [[ "$webconf_changed" -eq 1 ]]; then
	systemctl restart zynthian-webconf
fi

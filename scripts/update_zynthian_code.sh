#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Code
# 
# + Update the Zynthian Software from repositories.
# 
# Copyright (C) 2015-2019 Fernando Moyano <jofemodo@zynthian.org>
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
# Pull from repositories ...
#------------------------------------------------------------------------------

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git checkout .
git pull | grep -q -v 'Already up.to.date.' && ui_changed=1
./build.sh

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_UI_DIR
git checkout .
git pull | grep -q -v 'Already up.to.date.' && ui_changed=1
find ./zynlibs -type f -name build.sh -exec {} \;

echo "Updating zynthian-webconf ..."
cd $ZYNTHIAN_DIR/zynthian-webconf
git checkout .
git pull | grep -q -v 'Already up.to.date.' && webconf_changed=1

echo "Update Complete."

cd $ZYNTHIAN_CONFIG_DIR/jalv
if [[ "$(ls -1q | wc -l)" -lt 20 ]]; then
	echo "Regenerating cache LV2..."
	cd $ZYNTHIAN_UI_DIR/zyngine
	python3 ./zynthian_lv2.py
fi

if [ -f $REBOOT_FLAGFILE ]; then
	rm -f $REBOOT_FLAGFILE
	echo "Rebooting..."
	reboot
fi

if [[ "$ui_changed" -eq 1 ]]; then
	echo "Restarting zynthian service."
	systemctl restart zynthian
fi

if [[ "$webconf_changed" -eq 1 ]]; then
	echo "Restarting zynthian-webconf service."
	systemctl restart zynthian-webconf
fi


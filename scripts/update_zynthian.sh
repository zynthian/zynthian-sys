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

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

export REBOOT_FLAGFILE="/tmp/zynthian_reboot"
rm -f $REBOOT_FLAGFILE

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_SYS_DIR
git checkout .
git pull

cd ./scripts
./update_zynthian_sys.sh
./update_zynthian_data.sh
./update_zynthian_recipes.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git checkout .
git pull
cd build
cmake ..
make

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_UI_DIR
git checkout .
git pull
rm -f zynthian_gui_config_new.py

echo "Updating zynthian-webconf ..."
cd $ZYNTHIAN_DIR/zynthian-webconf
git checkout .
git pull | grep -q -v 'Already up-to-date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	systemctl stop zynthian-webconf
	systemctl start zynthian-webconf
fi

if [ -f $REBOOT_FLAGFILE ]; then
	rm -f $REBOOT_FLAGFILE
	reboot
fi

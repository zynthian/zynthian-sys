#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Data
# 
# + Update the Zynthian Data from repositories.
# + Perform some extra fixes
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

echo "Updating zynthian-data ..."
cd "$ZYNTHIAN_DATA_DIR"
git checkout .
git pull
cp -na $ZYNTHIAN_DATA_DIR/mod-pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards
cp -na $ZYNTHIAN_DATA_DIR/presets/lv2/* $ZYNTHIAN_MY_DATA_DIR/presets/lv2
cp -na $ZYNTHIAN_DATA_DIR/presets/puredata $ZYNTHIAN_MY_DATA_DIR/presets
cp -na $ZYNTHIAN_DATA_DIR/presets/zynaddsubfx/* $ZYNTHIAN_DATA_DIR/zynbanks

#echo "Updating zynthian-plugins ..."
#cd "$ZYNTHIAN_PLUGINS_DIR"
#git pull

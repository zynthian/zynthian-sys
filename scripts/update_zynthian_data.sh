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

if [ -f "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

echo "Updating zynthian-data ..."
cd "$ZYNTHIAN_DATA_DIR"
git checkout .
git pull

# Update user presets for some engines ...
cp -na $ZYNTHIAN_DATA_DIR/presets/lv2/* $ZYNTHIAN_MY_DATA_DIR/presets/lv2
cp -na $ZYNTHIAN_DATA_DIR/presets/puredata $ZYNTHIAN_MY_DATA_DIR/presets
cp -na $ZYNTHIAN_DATA_DIR/presets/zynaddsubfx/* $ZYNTHIAN_DATA_DIR/zynbanks

# Fix/Setup ZynAddSubFX user presets directory
if [ -L $ZYNTHIAN_MY_DATA_DIR/zynbanks ]; then
	rm -f $ZYNTHIAN_MY_DATA_DIR/zynbanks
fi

# Fix/Setup MOD-UI pedalboards directory
if [ -d $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards ]; then
	mkdir $ZYNTHIAN_MY_DATA_DIR/presets/mod-ui
	mv $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards $ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards
fi
cp -na $ZYNTHIAN_DATA_DIR/presets/mod-ui/pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards
rm -f /root/.pedalboards
ln -s $ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards /root/.pedalboards

# Fix/Setup setbfree user config directory
if [ -d "$ZYNTHIAN_MY_DATA_DIR/setbfree" ]; then
	mv "$ZYNTHIAN_MY_DATA_DIR/setbfree" $ZYNTHIAN_CONFIG_DIR
fi

# Reformat snapshot directory names, removing the first 2 leading zeros
for bdir in $ZYNTHIAN_MY_DATA_DIR/snapshots/00???; do
	if [ -d "$bdir" ]; then
		mv "$bdir" `echo "$bdir" | sed -e 's:\/00:\/:'`
	fi
done
for bdir in $ZYNTHIAN_MY_DATA_DIR/snapshots/00???-*; do
	if [ -d "$bdir" ]; then
		mv "$bdir" `echo "$bdir" | sed -e 's:\/00:\/:'`
	fi
done

# Fix/Setup snapshots directory
if [ ! -d $ZYNTHIAN_MY_DATA_DIR/snapshots/000 ]; then
	if [ -d $ZYNTHIAN_MY_DATA_DIR/snapshots/001 ]; then
		mv $ZYNTHIAN_MY_DATA_DIR/snapshots/001 $ZYNTHIAN_MY_DATA_DIR/snapshots/000
	else
		mkdir $ZYNTHIAN_MY_DATA_DIR/snapshots/000
	fi
fi


#echo "Updating zynthian-plugins ..."
#cd "$ZYNTHIAN_PLUGINS_DIR"
#git pull

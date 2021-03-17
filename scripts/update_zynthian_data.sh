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
# Move users from master to stable - master is deprecated
if [ `git rev-parse --abbrev-ref HEAD` == master ]; then git checkout stable; fi
git checkout .
git pull

# Create preset-favorites if needed
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/preset-favorites" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/preset-favorites"
fi

# Update user presets for some engines ...
cp -na $ZYNTHIAN_DATA_DIR/presets/zynaddsubfx/* $ZYNTHIAN_DATA_DIR/zynbanks

# Fix/Setup ZynAddSubFX user presets directory
if [ -L "$ZYNTHIAN_MY_DATA_DIR/zynbanks" ]; then
	rm -f "$ZYNTHIAN_MY_DATA_DIR/zynbanks"
fi

# Fix/Setup MOD-UI pedalboards directory: create dirs & symlinks, copy pedalboards ...
if [ -d "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui"
	mv "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards" "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards"
fi
cp -na $ZYNTHIAN_DATA_DIR/presets/mod-ui/pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards
rm -f "/root/.pedalboards"
ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards" "/root/.pedalboards"

# Fix/Setup MOD-UI lv2 presets directory
if [ -d "/root/.lv2" ] && [ ! -L "/root/.lv2" ]; then
	mv /root/.lv2/* $ZYNTHIAN_MY_DATA_DIR/presets/lv2
	rm -rf "/root/.lv2"
	ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/lv2" "/root/.lv2"
fi

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
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/snapshots/000" ]; then
	if [ -d "$ZYNTHIAN_MY_DATA_DIR/snapshots/001" ]; then
		mv "$ZYNTHIAN_MY_DATA_DIR/snapshots/001" "$ZYNTHIAN_MY_DATA_DIR/snapshots/000"
	else
		mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots/000"
	fi
fi

# Fix LV2 Presets
if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2" ]; then
	sed -i -- 's/a pset\:bank/a pset\:Bank/g' $ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2/*.ttl
fi
if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/dexed.lv2" ]; then
	sed -i -- 's/a pset\:bank/a pset\:Bank/g' $ZYNTHIAN_PLUGINS_DIR/lv2/dexed.lv2/*.ttl
fi
sed -i -- 's/a pset\:bank/a pset\:Bank/g' $ZYNTHIAN_MY_DATA_DIR/presets/lv2/*/*.ttl

#Link FluidPlug SF2s for using normally with FluidSynth
cd $ZYNTHIAN_PLUGINS_DIR/lv2
for d in AirFont320* AVL_Drumkits_Perc* Black_Pearl* Fluid* Red_Zeppelin*; do
	name=${d%.*}
	dest=$ZYNTHIAN_DATA_DIR/soundfonts/sf2/$name.sf2
	if [[ ( ! -L "$dest") && ( $name != "FluidGM" ) ]]; then
		echo "Linking $name.sf2 ..."
		ln -s "$ZYNTHIAN_PLUGINS_DIR/lv2/$d/FluidPlug.sf2" "$dest"
	fi
done

#echo "Updating zynthian-plugins ..."
#cd "$ZYNTHIAN_PLUGINS_DIR"
#git pull

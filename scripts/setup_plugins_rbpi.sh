#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Setup Zynthian Plugins from scratch for RBPi
# 
# Install LV2 Plugin Package / Download, build and install LV2 Plugins
# 
# Copyright (C) 2015-2016 Fernando Moyano <jofemodo@zynthian.org>
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
# 
#******************************************************************************

source zynthian_envars.sh

#------------------------------------------------
# Create Plugins Source Code Directory
#------------------------------------------------

mkdir $ZYNTHIAN_PLUGINS_SRC_DIR

#------------------------------------------------
# Install MOD Plugins
#------------------------------------------------

sh $ZYNTHIAN_RECIPE_DIR/install_mod-lv2-data.sh

sh $ZYNTHIAN_RECIPE_DIR/install_mod-mda.sh
sh $ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
sh $ZYNTHIAN_RECIPE_DIR/install_fluidplug.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_mod-setbfree.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
sh $ZYNTHIAN_RECIPE_DIR/install_midifilter.lv2.sh
sh $ZYNTHIAN_RECIPE_DIR/install_mod-utilities.sh
sh $ZYNTHIAN_RECIPE_DIR/install_step-seq.sh
sh $ZYNTHIAN_RECIPE_DIR/install_openav-artyfx.sh
sh $ZYNTHIAN_RECIPE_DIR/install-calf.sh
sh $ZYNTHIAN_RECIPE_DIR/install_eq10q.sh
sh $ZYNTHIAN_RECIPE_DIR/install_guitarix.sh
sh $ZYNTHIAN_RECIPE_DIR/install_mclk.sh
sh $ZYNTHIAN_RECIPE_DIR/install_mod-caps.sh
sh $ZYNTHIAN_RECIPE_DIR/install_mod-distortion.sh
sh $ZYNTHIAN_RECIPE_DIR/install_mod-pitchshifter.sh
sh $ZYNTHIAN_RECIPE_DIR/install_mod-tap.sh
sh $ZYNTHIAN_RECIPE_DIR/install_sooperlooper-lv2-plugin.sh
sh $ZYNTHIAN_RECIPE_DIR/install_sosynth.sh
sh $ZYNTHIAN_RECIPE_DIR/install_fat1.sh
sh $ZYNTHIAN_RECIPE_DIR/install_gxslowgear.sh
sh $ZYNTHIAN_RECIPE_DIR/install_gxswitchlesswah.sh
sh $ZYNTHIAN_RECIPE_DIR/install_gxvintagefuzz.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_gxsupertoneblender.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_gxsuperfuzz.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_gxvoodofuzz.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_gxsupersaturator.sh
#sh $ZYNTHIAN_RECIPE_DIR/install_gxhyperion.sh

sh $ZYNTHIAN_RECIPE_DIR/postinstall_mod-lv2-data.sh

#------------------------------------------------
# Install v1 suit
#------------------------------------------------
apt-get -y install synthv1 samplv1 drumkv1
ln -s /usr/lib/lv2/synthv1.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/samplv1.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/drumkv1.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

#------------------------------------------------
# Install some extra LV2 Plugins (swh, avw, ...)
#------------------------------------------------
apt-get -y install swh-lv2 lv2vocoder avw.lv2
ln -s /usr/lib/lv2/*swh.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/vocoder.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/avw.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

exit

#------------------------------------------------
# Install some extra LV2 Plugins (Calf, MDA, ...)
#------------------------------------------------
#apt-get install calf-plugins mda-lv2

#------------------------------------------------
# Install DISTRHO DPF-Plugins
#------------------------------------------------
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/DISTRHO/DPF-Plugins.git
cd DPF-Plugins
export RASPPI=true
make -j 4
make install

#------------------------------------------------
# Install DISTRHO Plugins-Ports
#------------------------------------------------
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/DISTRHO/DISTRHO-Ports.git
cd DISTRHO-Ports
./scripts/premake-update.sh linux
#edit ./scripts/premake.lua
make -j 4
make install

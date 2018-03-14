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

bash $ZYNTHIAN_RECIPE_DIR/install_mod-mda.sh
bash $ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
bash $ZYNTHIAN_RECIPE_DIR/install_fluidplug.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_mod-setbfree.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
bash $ZYNTHIAN_RECIPE_DIR/install_midifilter.lv2.sh
bash $ZYNTHIAN_RECIPE_DIR/install_mod-utilities.sh
bash $ZYNTHIAN_RECIPE_DIR/install_step-seq.sh
bash $ZYNTHIAN_RECIPE_DIR/install_openav-artyfx.sh
bash $ZYNTHIAN_RECIPE_DIR/install-calf.sh
bash $ZYNTHIAN_RECIPE_DIR/install_eq10q.sh
bash $ZYNTHIAN_RECIPE_DIR/install_guitarix.sh
bash $ZYNTHIAN_RECIPE_DIR/install_mclk.sh
bash $ZYNTHIAN_RECIPE_DIR/install_mod-caps.sh
bash $ZYNTHIAN_RECIPE_DIR/install_mod-distortion.sh
bash $ZYNTHIAN_RECIPE_DIR/install_mod-pitchshifter.sh
bash $ZYNTHIAN_RECIPE_DIR/install_mod-tap.sh
bash $ZYNTHIAN_RECIPE_DIR/install_sooperlooper-lv2-plugin.sh
bash $ZYNTHIAN_RECIPE_DIR/install_sosynth.sh
bash $ZYNTHIAN_RECIPE_DIR/install_fat1.sh
bash $ZYNTHIAN_RECIPE_DIR/install_gxslowgear.sh
bash $ZYNTHIAN_RECIPE_DIR/install_gxswitchlesswah.sh
bash $ZYNTHIAN_RECIPE_DIR/install_gxvintagefuzz.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_gxsupertoneblender.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_gxsuperfuzz.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_gxvoodofuzz.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_gxsupersaturator.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_gxhyperion.sh
bash $ZYNTHIAN_RECIPE_DIR/install_helm.sh
bash $ZYNTHIAN_RECIPE_DIR/install_infamous.sh
bash $ZYNTHIAN_RECIPE_DIR/install_padthv1.sh

# dcoredump Stuff
bash $ZYNTHIAN_RECIPE_DIR/install_lvtk.sh
bash $ZYNTHIAN_RECIPE_DIR/install_dxsyx.sh
#bash $ZYNTHIAN_RECIPE_DIR/install_deeaxe7.sh
bash $ZYNTHIAN_RECIPE_DIR/install_dexed_dcoredump.sh

bash $ZYNTHIAN_RECIPE_DIR/postinstall_mod-lv2-data.sh

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
apt-get -y --no-install-recommends install swh-lv2 lv2vocoder avw.lv2 invada-studio-plugins-lv2
ln -s /usr/lib/lv2/*swh.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/vocoder.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
# Some AVW plugins are broken, so it's disabled by now
#ln -s /usr/lib/lv2/avw.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/invada.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
	
#------------------------------------------------
# Install some LADSPA plugins for LinuxSampler
#------------------------------------------------

apt-get -y install ladspa-sdk wah-plugins tap-plugins vco-plugins swh-plugins ste-plugins rev-plugins omins mcp-plugins invada-studio-plugins-ladspa rubberband-ladspa fil-plugins csladspa cmt caps bs2b-ladspa blop blepvco autotalent ambdec amb-plugins

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

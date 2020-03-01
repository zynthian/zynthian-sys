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
# Link LV2 Core Data-Plugins
#------------------------------------------------

ln -s /usr/local/lib/lv2/atom.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/data-access.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/parameters.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/dynmanifest.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/event.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/patch.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/time.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/instance-access.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/port-groups.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/ui.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/log.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/port-props.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/units.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/buf-size.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
#ln -s /usr/local/lib/lv2/lv2core.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/core.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/presets.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/urid.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/midi.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/resize-port.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/uri-map.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/schemas.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/worker.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/options.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/state.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/local/lib/lv2/eg-*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

#------------------------------------------------
# Create Plugins Source Code Directory
#------------------------------------------------

mkdir $ZYNTHIAN_PLUGINS_SRC_DIR

#------------------------------------------------
# Install LV2 Plugins
#------------------------------------------------

$ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-setbfree.sh
#$ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
#$ZYNTHIAN_RECIPE_DIR/install_linuxsampler.sh
$ZYNTHIAN_RECIPE_DIR/install_fluidplug.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-mda.sh
$ZYNTHIAN_RECIPE_DIR/install_midifilter.lv2.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-utilities.sh
$ZYNTHIAN_RECIPE_DIR/install_step-seq.sh
$ZYNTHIAN_RECIPE_DIR/install_openav-artyfx.sh
$ZYNTHIAN_RECIPE_DIR/install_calf.sh
$ZYNTHIAN_RECIPE_DIR/install_eq10q.sh
$ZYNTHIAN_RECIPE_DIR/install_mclk.sh
$ZYNTHIAN_RECIPE_DIR/install_sooperlooper-lv2-plugin.sh
$ZYNTHIAN_RECIPE_DIR/install_sosynth.sh
$ZYNTHIAN_RECIPE_DIR/install_fat1.sh
$ZYNTHIAN_RECIPE_DIR/install_guitarix.sh
$ZYNTHIAN_RECIPE_DIR/install_gxswitchlesswah.sh
$ZYNTHIAN_RECIPE_DIR/install_gxdenoiser2.sh
$ZYNTHIAN_RECIPE_DIR/install_gxdistortionplus.sh
$ZYNTHIAN_RECIPE_DIR/install_gxplugins.sh
#$ZYNTHIAN_RECIPE_DIR/install_gxsupersaturator.sh
#$ZYNTHIAN_RECIPE_DIR/install_helm.sh
$ZYNTHIAN_RECIPE_DIR/install_infamous.sh
$ZYNTHIAN_RECIPE_DIR/install_padthv1.sh
#$ZYNTHIAN_RECIPE_DIR/install_distrho_ports.sh
$ZYNTHIAN_RECIPE_DIR/install_dpf_plugins.sh
$ZYNTHIAN_RECIPE_DIR/install_foo-yc20.sh
$ZYNTHIAN_RECIPE_DIR/install_triceratops.sh
$ZYNTHIAN_RECIPE_DIR/install_swh.sh
$ZYNTHIAN_RECIPE_DIR/install_shiro.sh
$ZYNTHIAN_RECIPE_DIR/install_raffo.sh
$ZYNTHIAN_RECIPE_DIR/install_zam.sh
$ZYNTHIAN_RECIPE_DIR/install_x42_testsignal.sh
$ZYNTHIAN_RECIPE_DIR/install_dragonfly.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-caps.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-distortion.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-pitchshifter.sh => DISABLED BECAUSE IT FAILS BUSTER BUILD
$ZYNTHIAN_RECIPE_DIR/install_mod-tap.sh
$ZYNTHIAN_RECIPE_DIR/install_ams-lv2.sh
$ZYNTHIAN_RECIPE_DIR/install_amsynth.sh
$ZYNTHIAN_RECIPE_DIR/install_dexed_dcoredump.sh
$ZYNTHIAN_RECIPE_DIR/install_setBfree-controller.sh
$ZYNTHIAN_RECIPE_DIR/install_string-machine.sh
$ZYNTHIAN_RECIPE_DIR/install_midi_display.sh
$ZYNTHIAN_RECIPE_DIR/install_punk_console.sh
$ZYNTHIAN_RECIPE_DIR/install_reMID.sh
#$ZYNTHIAN_RECIPE_DIR/install_ADLplug.sh
$ZYNTHIAN_RECIPE_DIR/install_miniopl3.sh
$ZYNTHIAN_RECIPE_DIR/install_ykchorus.sh

$ZYNTHIAN_RECIPE_DIR/install_lv2_plugins_prebuilt.sh

#------------------------------------------------
# Install v1 suit
#------------------------------------------------
apt-get -y install synthv1 samplv1 drumkv1
apt-get -y install drumkv1-lv2 samplv1-lv2 synthv1-lv2
ln -s /usr/lib/lv2/synthv1.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/samplv1.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/drumkv1.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

#------------------------------------------------
# Install some extra LV2 Plugins
#------------------------------------------------
apt-get -y --no-install-recommends install lv2vocoder avw.lv2 invada-studio-plugins-lv2
ln -s /usr/lib/lv2/vocoder.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
ln -s /usr/lib/lv2/invada.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
# Some AVW plugins are broken, so it's disabled by now
#ln -s /usr/lib/lv2/avw.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
#apt-get -y install mda-lv2

#------------------------------------------------
# Install LADSPA plugins for LinuxSampler => Not used anymore!
#------------------------------------------------

#apt-get -y install ladspa-sdk wah-plugins tap-plugins vco-plugins swh-plugins ste-plugins rev-plugins omins mcp-plugins invada-studio-plugins-ladspa rubberband-ladspa fil-plugins csladspa cmt caps bs2b-ladspa blop blepvco autotalent ambdec amb-plugins

$ZYNTHIAN_RECIPE_DIR/postinstall_mod-lv2-data.sh

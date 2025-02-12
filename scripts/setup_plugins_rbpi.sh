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

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------
# Create Plugins Source Code Directory
#------------------------------------------------

mkdir $ZYNTHIAN_PLUGINS_SRC_DIR

#------------------------------------------------
# Install LV2 Plugins from repository
#------------------------------------------------

apt-get -y install abgate adlplug amsynth ams-lv2 arctican-plugins-lv2 artyfx \
bchoppr beatslash-lv2 blop-lv2 bsequencer bshapr bslizr calf-plugins caps-lv2 cv-lfo-blender-lv2 \
drumkv1-lv2 distrho-plugin-ports-lv2 dpf-plugins dragonfly-reverb drmr drowaudio-plugins-lv2 drumgizmo \
easyssp-lv2 eq10q fabla g2reverb geonkick gxplugins gxvoxtonebender helm hybridreverb2 \
infamous-plugins invada-studio-plugins-lv2 juced-plugins-lv2 juce-opl-lv2 klangfalter-lv2 \
lsp-plugins lufsmeter-lv2 luftikus-lv2 lv2vocoder \
mod-cv-plugins mod-distortion mod-pitchshifter mod-utilities moony.lv2 noise-repellent \
obxd-lv2 oxefmsynth padthv1-lv2 pitcheddelay-lv2 pizmidi-plugins regrader rubberband-lv2 \
safe-plugins samplv1-lv2 shiro-plugins synthv1-lv2 sorcer surge \
temper-lv2 tal-plugins-lv2 tap-lv2 teragonaudio-plugins-lv2 vitalium-lv2 \
wolf-shaper wolf-spectrum wolpertinger-lv2 zam-plugins zlfo


# TODO review:
# avw.lv2 riban-lv2 boops

#------------------------------------------------
# Install LV2 Plugins from source code
#------------------------------------------------

#$ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
$ZYNTHIAN_RECIPE_DIR/install_fluidplug.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-setbfree.sh
#$ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
#$ZYNTHIAN_RECIPE_DIR/install_linuxsampler.sh
#$ZYNTHIAN_RECIPE_DIR/install_openav-artyfx.sh
#$ZYNTHIAN_RECIPE_DIR/install_calf.sh
#$ZYNTHIAN_RECIPE_DIR/install_eq10q.sh
#$ZYNTHIAN_RECIPE_DIR/install_ADLplug.sh
#$ZYNTHIAN_RECIPE_DIR/install_ams-lv2.sh
#$ZYNTHIAN_RECIPE_DIR/install_amsynth.sh
#$ZYNTHIAN_RECIPE_DIR/install_sooperlooper-lv2-plugin.sh
$ZYNTHIAN_RECIPE_DIR/install_sosynth.sh
$ZYNTHIAN_RECIPE_DIR/install_guitarix.sh
$ZYNTHIAN_RECIPE_DIR/install_gxswitchlesswah.sh
$ZYNTHIAN_RECIPE_DIR/install_gxdenoiser2.sh
$ZYNTHIAN_RECIPE_DIR/install_gxdistortionplus.sh
#$ZYNTHIAN_RECIPE_DIR/install_gxplugins.sh
#$ZYNTHIAN_RECIPE_DIR/install_gxsupersaturator.sh
#$ZYNTHIAN_RECIPE_DIR/install_helm.sh
#$ZYNTHIAN_RECIPE_DIR/install_infamous.sh
#$ZYNTHIAN_RECIPE_DIR/install_padthv1.sh
#$ZYNTHIAN_RECIPE_DIR/install_distrho_ports.sh
#$ZYNTHIAN_RECIPE_DIR/install_dpf_plugins.sh
$ZYNTHIAN_RECIPE_DIR/install_foo-yc20.sh
$ZYNTHIAN_RECIPE_DIR/install_raffo.sh
$ZYNTHIAN_RECIPE_DIR/install_triceratops.sh
$ZYNTHIAN_RECIPE_DIR/install_swh.sh
#$ZYNTHIAN_RECIPE_DIR/install_shiro.sh
#$ZYNTHIAN_RECIPE_DIR/install_zam.sh
#$ZYNTHIAN_RECIPE_DIR/install_dragonfly.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-caps.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-distortion.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-pitchshifter.sh => DISABLED BECAUSE IT FAILS BUSTER BUILD
#$ZYNTHIAN_RECIPE_DIR/install_mod-utilities.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-tap.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-mda.sh
#$ZYNTHIAN_RECIPE_DIR/install_dexed_lv2.sh
$ZYNTHIAN_RECIPE_DIR/install_setBfree-controller.sh
$ZYNTHIAN_RECIPE_DIR/install_string-machine.sh
$ZYNTHIAN_RECIPE_DIR/install_midi_display.sh
$ZYNTHIAN_RECIPE_DIR/install_punk_console.sh
$ZYNTHIAN_RECIPE_DIR/install_reMID.sh
$ZYNTHIAN_RECIPE_DIR/install_miniopl3.sh
$ZYNTHIAN_RECIPE_DIR/install_ykchorus.sh
$ZYNTHIAN_RECIPE_DIR/install_gula.sh
#$ZYNTHIAN_RECIPE_DIR/install_arpeggiator.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-arpeggiator.sh
$ZYNTHIAN_RECIPE_DIR/install_stereo-mixer.sh
$ZYNTHIAN_RECIPE_DIR/install_alo.sh
$ZYNTHIAN_RECIPE_DIR/install_VL1.sh
$ZYNTHIAN_RECIPE_DIR/install_mod-cabsim-IR-loader.sh
$ZYNTHIAN_RECIPE_DIR/install_bolliedelay.sh
$ZYNTHIAN_RECIPE_DIR/install_talentedhack.sh
$ZYNTHIAN_RECIPE_DIR/install_mimi.sh
$ZYNTHIAN_RECIPE_DIR/install_avldrums.sh

# Faust LV2 plugins =>
# Fallan algunos al construir, pero el Granulator funciona!!
$ZYNTHIAN_RECIPE_DIR/install_faust_lv2.sh

# X42 plugins
$ZYNTHIAN_RECIPE_DIR/install_x42_plugins.sh

# Zynthian pre-compiled plugins
$ZYNTHIAN_RECIPE_DIR/install_dexed_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_monique_monosynth_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_odin2_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_argotlunar2_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_qmidiarp_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_dsp56300_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_nam_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_ratatouille_prebuilt.sh
$ZYNTHIAN_RECIPE_DIR/install_nam_models.sh
$ZYNTHIAN_RECIPE_DIR/install_surge_xt_prebuilt.sh
mkdir "/root/.Surge XT"

# Fixup amsynth bank/presets
$ZYNTHIAN_RECIPE_DIR/fixup_amsynth.sh

# Install MOD-UI skins
#$ZYNTHIAN_RECIPE_DIR/postinstall_mod-lv2-data.sh

# Remove source code we don't need
# TODO!

# Remove VSTs and other plugin format we don't need and take a lot of space
rm -rf /usr/lib/vst
rm -rf /usr/lib/dssi
rm -rf /usr/lib/ladspa
rm -rf /usr/local/lib/vst
rm -rf /usr/local/lib/dssi
rm -rf /usr/local/lib/ladspa
rm -rf /usr/lib/lsp-plugins
rm -f /usr/bin/lsp-*

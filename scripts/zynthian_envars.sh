#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Environment Vars
# 
# Setup Zynthian Environment Variables
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
# ****************************************************************************

#Audio Config
export SOUNDCARD_NAME="HifiBerry DAC+"
export SOUNDCARD_CONFIG="dtoverlay=hifiberry-dacplus"
export JACKD_OPTIONS="-P 70 -t 2000 -s -d alsa -d hw:0 -r 44100 -p 256 -n 2 -X raw"

#Display Config
export DISPLAY_NAME="PiTFT 2.8 Resistive"
export DISPLAY_CONFIG="dtoverlay=pitft28-resistive,rotate=90,speed=32000000,fps=20"
export DISPLAY_WIDTH=""
export DISPLAY_HEIGHT=""
export FRAMEBUFFER="/dev/fb1"

# Zynthian Features Flags
export ZYNTHIAN_AUBIONOTES=1
export ZYNTHIAN_TOUCHOSC=1

# Zynthian Wiring Config
export ZYNTHIAN_WIRING_LAYOUT="PROTOTYPE-4"
export ZYNTHIAN_WIRING_ENCODER_A=""
export ZYNTHIAN_WIRING_ENCODER_B=""
export ZYNTHIAN_WIRING_SWITCHES=""

# Zynthian UI Config
export ZYNTHIAN_UI_COLOR_BG="#000000"
export ZYNTHIAN_UI_COLOR_TX="#ffffff"
export ZYNTHIAN_UI_COLOR_ON="#ff0000"
export ZYNTHIAN_UI_COLOR_PANEL_BG="#3a424d"
export ZYNTHIAN_UI_FONT_FAMILY="Audiowide"
export ZYNTHIAN_UI_FONT_SIZE="10"
export ZYNTHIAN_UI_ENABLE_CURSOR="0"
export ZYNTHIAN_MASTER_MIDI_CHANNEL="16"
export ZYNTHIAN_MASTER_MIDI_PROGRAM_CHANGE_TYPE="Roland"
export ZYNTHIAN_MASTER_MIDI_PROGRAM_CHANGE_DOWN="C#00"
export ZYNTHIAN_MASTER_MIDI_PROGRAM_CHANGE_UP="C#7F"
export ZYNTHIAN_MIDI_FINE_TUNING="440"
export ZYNTHIAN_MASTER_MIDI_BANK_CHANGE_DOWN="B#0000"
export ZYNTHIAN_MASTER_MIDI_BANK_CHANGE_UP="B#007F"
export ZYNTHIAN_PRESET_PRELOAD_NOTEON="1"

# Directory Paths
export ZYNTHIAN_DIR="/zynthian"
export ZYNTHIAN_CONFIG_DIR="$ZYNTHIAN_DIR/config"
export ZYNTHIAN_SW_DIR="$ZYNTHIAN_DIR/zynthian-sw"
export ZYNTHIAN_UI_DIR="$ZYNTHIAN_DIR/zynthian-ui"
export ZYNTHIAN_SYS_DIR="$ZYNTHIAN_DIR/zynthian-sys"
export ZYNTHIAN_DATA_DIR="$ZYNTHIAN_DIR/zynthian-data"
export ZYNTHIAN_MY_DATA_DIR="$ZYNTHIAN_DIR/zynthian-my-data"
export ZYNTHIAN_RECIPE_DIR="$ZYNTHIAN_SYS_DIR/scripts/recipes"
export ZYNTHIAN_PLUGINS_DIR="$ZYNTHIAN_DIR/zynthian-plugins"
export ZYNTHIAN_MY_PLUGINS_DIR="$ZYNTHIAN_DIR/zynthian-my-plugins"
export ZYNTHIAN_PLUGINS_SRC_DIR="$ZYNTHIAN_SW_DIR/plugins"
export LV2_PATH="$ZYNTHIAN_PLUGINS_DIR/lv2:$ZYNTHIAN_MY_PLUGINS_DIR/lv2:$ZYNTHIAN_MY_DATA_DIR/presets/lv2"

# Hardware Architecture & Optimization Options
machine=`uname -m 2>/dev/null`
if [ ${machine} = "armv7l" ]; then
	model=`cat /sys/firmware/devicetree/base/model 2>/dev/null`
	if [[ ${model} =~ [3] ]]; then
		CPU="-mcpu=cortex-a53"
		FPU="-mfpu=neon-fp-armv8 -mneon-for-64bits"
	else
		CPU="-mcpu=cortex-a7 -mthumb"
		FPU="-mfpu=neon-vfpv4"
	fi
	FPU="${FPU} -mfloat-abi=hard -mvectorize-with-neon-quad"
	CFLAGS_UNSAFE="-funsafe-loop-optimizations -funsafe-math-optimizations"
fi
export MACHINE_HW_NAME=$machine
export RBPI_VERSION=$model
export CFLAGS="${CPU} ${FPU}"
export CXXFLAGS=${CFLAGS}
export CFLAGS_UNSAFE
#echo "Hardware Architecture: ${machine}"
#echo "Hardware Model: ${model}"

# Setup / Build Options
export ZYNTHAIN_SETUP_APT_CLEAN="TRUE" # Set TRUE to clean /var/cache/apt during build, FALSE to leave alone

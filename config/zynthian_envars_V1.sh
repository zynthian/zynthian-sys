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

export ZYNTHIAN_KIT_VERSION="V1"

# System Config
export BOOTLOG="1"
export ZYNTHIAN_CUSTOM_BOOT_CMDLINE=""
export ZYNTHIAN_CUSTOM_CONFIG=""
export ZYNTHIAN_OVERCLOCKING="None"
export ZYNTHIAN_LIMIT_USB_SPEED="0"
export ZYNTHIAN_DISABLE_OTG="0"
export ZYNTHIAN_WIFI_MODE="off"

#Audio Config
export SOUNDCARD_NAME="HifiBerry DAC+"
export SOUNDCARD_CONFIG="dtoverlay=hifiberry-dacplus\nforce_eeprom_read=0"
export SOUNDCARD_MIXER="Digital_0,Digital_1"
export JACKD_OPTIONS="-P 70 -s -S -d alsa -d hw:sndrpihifiberry -r 44100 -p 256 -n 2 -X raw"

#Display Config
export DISPLAY_NAME="PiTFT 2.8 Resistive"
export DISPLAY_CONFIG="dtoverlay=pitft28-resistive,rotate=90,speed=32000000,fps=20"
export DISPLAY_WIDTH="320"
export DISPLAY_HEIGHT="240"
export FRAMEBUFFER="/dev/fb1"
export DISPLAY_KERNEL_OPTIONS=""

# Zynthian Wiring Config
export ZYNTHIAN_WIRING_LAYOUT="PROTOTYPE-4"
export ZYNTHIAN_WIRING_ENCODER_A="26,25,0,4"
export ZYNTHIAN_WIRING_ENCODER_B="21,27,7,3"
export ZYNTHIAN_WIRING_SWITCHES="107,23,106,2"
export ZYNTHIAN_WIRING_MCP23017_I2C_ADDRESS="0x20"
export ZYNTHIAN_WIRING_MCP23017_INTA_PIN=""
export ZYNTHIAN_WIRING_MCP23017_INTB_PIN=""

# Zynthian UI Config
export ZYNTHIAN_UI_COLOR_BG="#000000"
export ZYNTHIAN_UI_COLOR_TX="#ffffff"
export ZYNTHIAN_UI_COLOR_ON="#ff0000"
export ZYNTHIAN_UI_COLOR_PANEL_BG="#3a424d"
export ZYNTHIAN_UI_FONT_FAMILY="Audiowide"
export ZYNTHIAN_UI_FONT_SIZE="11"
export ZYNTHIAN_UI_ENABLE_CURSOR="0"
export ZYNTHIAN_UI_TOUCH_WIDGETS="0"
export ZYNTHIAN_UI_RESTORE_LAST_STATE="1"
export ZYNTHIAN_UI_SNAPSHOT_MIXER_SETTINGS="1"
export ZYNTHIAN_UI_SWITCH_BOLD_MS="300"
export ZYNTHIAN_UI_SWITCH_LONG_MS="2000"
export ZYNTHIAN_UI_SHOW_CPU_STATUS="0"
export ZYNTHIAN_UI_ONSCREEN_BUTTONS="0"
export ZYNTHIAN_UI_VISIBLE_MIXER_STRIPS="0"
export ZYNTHIAN_UI_MULTICHANNEL_RECORDER="1"
export ZYNTHIAN_VNCSERVER_ENABLED="0"
export ZYNTHIAN_MIDI_PLAY_LOOP="0"

# MIDI system configuration
export ZYNTHIAN_SCRIPT_MIDI_PROFILE="/zynthian/config/midi-profiles/default.sh"
export ZYNTHIAN_USB_MIDI_BY_PORT="0"

# Extra features
export ZYNTHIAN_AUBIONOTES_OPTIONS="-O complex -t 0.5 -s -88  -p yinfft -l 0.5"
#export ZYNTHIAN_AUBIONOTES_OPTIONS="-O hfc -t 0.5 -s -60 -p yinfft -l 0.6"

# Directory Paths
export ZYNTHIAN_DIR="/zynthian"
export ZYNTHIAN_CONFIG_DIR="$ZYNTHIAN_DIR/config"
export ZYNTHIAN_SW_DIR="$ZYNTHIAN_DIR/zynthian-sw"
export ZYNTHIAN_UI_DIR="$ZYNTHIAN_DIR/zynthian-ui"
export ZYNTHIAN_SYS_DIR="$ZYNTHIAN_DIR/zynthian-sys"
export ZYNTHIAN_DATA_DIR="$ZYNTHIAN_DIR/zynthian-data"
export ZYNTHIAN_MY_DATA_DIR="$ZYNTHIAN_DIR/zynthian-my-data"
export ZYNTHIAN_EX_DATA_DIR="/media/root"
export ZYNTHIAN_RECIPE_DIR="$ZYNTHIAN_SYS_DIR/scripts/recipes"
export ZYNTHIAN_PLUGINS_DIR="$ZYNTHIAN_DIR/zynthian-plugins"
export ZYNTHIAN_PLUGINS_SRC_DIR="$ZYNTHIAN_SW_DIR/plugins"
export LV2_PATH="/usr/lib/lv2:/usr/lib/arm-linux-gnueabih/lv2:/usr/local/lib/lv2:/usr/local/lib/arm-linux-gnueabih/lv2:/zynthian/zynthian-plugins/lv2:/zynthian/zynthian-data/presets/lv2:/zynthian/zynthian-my-data/presets/lv2"

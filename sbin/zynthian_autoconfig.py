#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: Zynthian Hardware Autoconfig
#
# Auto-detect & config some hardware configurations
#
# Copyright (C) 2023 Fernando Moyano <jofemodo@zynthian.org>
#
# ********************************************************************
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
# ********************************************************************

import os
import sys
import logging
from subprocess import check_output

# --------------------------------------------------------------------
# Hardware's config for several boards:
# --------------------------------------------------------------------

hardware_config = {
	"Z2_MAIN_BETA": ["PCM1863@0x4A", "PCM5242@0x4D"],
	"Z2_MAIN": ["PCM1863@0x4A", "PCM5242@0x4D", "RV3028@0x52"],
	"Z2_CONTROL": ["MCP23017@0x20", "MCP23017@0x21", "ADS1115@0x48", "ADS1115@0x49"],

	"V5_MAIN": ["PCM1863@0x4A", "PCM5242@0x4D", "RV3028@0x52", "TPA6130@0x60"],
	"V5_CONTROL": ["MCP23017@0x20", "MCP23017@0x21"],

	"HifiBerryDAC+": ["PCM5242@0x4D"],
	"ZynADAC": ["PCM1863@0x4A", "PCM5242@0x4D"],
	"ZynScreen": ["MCP23017@0x20"],
	"Zynaptik": ["MCP23017@0x21", "ADS1115@0x48", "MCP4728@0x64"]
}

# --------------------------------------------------------------------
# Functions
# --------------------------------------------------------------------


def get_i2c_chips():
	res = []
	out = check_output("i2cdetect -y 1", shell=True).decode().split("\n")
	if len(out) > 3:
		for i in range(0, 8):
			parts = out[i+1][4:].split(" ")
			for j in range(0, 16):
				try:
					adr = i * 16 + j
					#print("Detecting at {:02X} => {}".format(adr, parts[j]))
					if parts[j] != "--":
						if 0x20 <= adr <= 0x27:
							res.append("MCP23017@0x{:02X}".format(adr))
						elif 0x48 <= adr <= 0x49:
							res.append("ADS1115@0x{:02X}".format(adr))
						elif adr == 0x4A:
							res.append("PCM1863@0x{:02X}".format(adr))
						elif adr == 0x4D:
							res.append("PCM5242@0x{:02X}".format(adr))
						elif adr == 0x52:
							res.append("RV3028@0x{:02X}".format(adr))
						#elif adr == 0x60 and parts[j] == "UU":
						elif adr == 0x60:
							res.append("TPA6130@0x{:02X}".format(adr))
						elif 0x61 <= adr <= 0x64:
							res.append("MCP4728@0x{:02X}".format(adr))
				except:
					pass
	return res


def check_boards(board_names):
	print("Checking Boards: {}".format(board_names))
	faults = []
	for bname in board_names:
		for chip in hardware_config[bname]:
			if chip not in i2c_chips:
				faults.append(chip)
	if len(faults) > 0:
		print("ERROR: Undetected Hardware {}".format(faults))
		return False
	else:
		print("OK: All hardware has been detected!")
		return True


def autodetect_config():
	if check_boards(["V5_MAIN", "V5_CONTROL"]):
		config_name = "V5"
	elif check_boards(["Z2_MAIN", "V5_CONTROL"]):
		config_name = "V5"
	elif check_boards(["Z2_MAIN", "Z2_CONTROL"]):
		config_name = "Z2"
	elif check_boards(["Z2_MAIN_BETA", "Z2_CONTROL"]):
		config_name = "Z2"
	elif check_boards(["ZynADAC", "ZynScreen"]):
		config_name = "V4"
	elif check_boards(["HifiBerryDAC+", "ZynScreen"]):
		config_name = "V2"
	else:
		config_name = "Custom"
	return config_name

# --------------------------------------------------------------------

# Get list of i2c chips
i2c_chips = get_i2c_chips()
print(f"Detected I2C Chips: {i2c_chips}")

# Detect kit version
config_name = autodetect_config()
print(f"Detected {config_name} kit!")

# Configure Zynthian
if config_name:
	if config_name != os.environ.get('ZYNTHIAN_KIT_VERSION'):
		print(f"Configuring Zynthian for {config_name} ...")

		if config_name == "V5" and os.environ.get('RBPI_VERSION_NUMBER') == '5':
			config_file = f"zynthian_envars_{config_name}_pi5.sh"
		else:
			config_file = f"zynthian_envars_{config_name}.sh"

		zyn_dir = os.environ.get('ZYNTHIAN_DIR', "/zynthian")
		zsys_dir = os.environ.get('ZYNTHIAN_SYS_DIR', "/zynthian/zynthian-sys")
		zconfig_dir = os.environ.get('ZYNTHIAN_CONFIG_DIR', "/zynthian/config")
		
		check_output(f"cp -a '{zsys_dir}/config/{config_file}' '{zconfig_dir}/zynthian_envars.sh'", shell=True)
		check_output(f"{zsys_dir}/scripts/update_zynthian_sys.sh", shell=True)
		check_output(f"rm -rf {zyn_dir}/zyncoder/build", shell=True)
		check_output(f"rm -rf {zconfig_dir}/img", shell=True)
		check_output(f"{zsys_dir}/scripts/delayed_action_flags.sh set reboot", shell=True)
	else:
		print(f"Zynthian already configured for {config_name}.")
else:
	print("Autoconfig for this HW footprint is not available.")

# --------------------------------------------------------------------

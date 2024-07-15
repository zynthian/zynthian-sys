#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: Zynthian Hardware Detection
#
# Detect zynthian's hardware
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

if len(sys.argv) > 1:
	board_names = sys.argv[1]
else:
	board_names = None

kit_name = os.environ.get('ZYNTHIAN_KIT_VERSION')

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
print("Detected I2C Chips: {}".format(i2c_chips))

# Select boards to test
if board_names:
	board_names = [s.strip() for s in board_names.split(',')]
elif kit_name:
	board_names = []
	for bname in hardware_config.keys():
		if bname.startswith(kit_name):
			board_names.append(bname)

# Check chip presence for selected boards
if len(board_names) > 0:
	check_boards(board_names)
else:
	print("ERROR: Nothing to detect!")

# --------------------------------------------------------------------

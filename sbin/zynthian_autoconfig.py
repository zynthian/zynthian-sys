#!/usr/bin/python3
# -*- coding: utf-8 -*-
#********************************************************************
# ZYNTHIAN PROJECT: Zynthian Hardware Autoconfig
#
# Auto-detect & config some hardware configurations
#
# Copyright (C) 2022 Fernando Moyano <jofemodo@zynthian.org>
#
#********************************************************************
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
#********************************************************************

import os
import logging
from subprocess import check_output

#--------------------------------------------------------------------

def get_i2c_chips():
	out=check_output("gpio i2cd", shell=True).decode().split("\n")
	if len(out)>3:
		res = []
		for i in range(1,8):
			for adr in out[i][4:].split(" "):
				try:
					adr = int(adr, 16)
					if adr>=0x20 and adr<=0x27:
						res.append("MCP23017@0x{:02X}".format(adr))
					elif adr>=0x48 and adr<=0x4B:
						res.append("ADS1115@0x{:02X}".format(adr))
					elif adr>=0x60 and adr<=0x67:
						res.append("MCP4728@0x{:02X}".format(adr))
				except:
					pass
	return res

#--------------------------------------------------------------------
	
# Get i2c chips info and format like webconf's dashboard
i2c_chips = get_i2c_chips()
if len(i2c_chips)>0:
	i2c_info = ", ".join(map(str, i2c_chips))
else:
	i2c_info = "Not detected"

print("Hardware footprint: {}".format(i2c_info))

# Detect Z2's hardware footprint & and config 
if i2c_info == "MCP23017@0x20, MCP23017@0x21, ADS1115@0x48, ADS1115@0x49":
	config_name = "Z2"
else:
	config_name = None

# Configure Zynthian
if config_name:
	if config_name != os.environ.get('ZYNTHIAN_KIT_VERSION'):
		print("Configuring Zynthian for {} ...".format(config_name))

		zyn_dir = os.environ.get('ZYNTHIAN_DIR',"/zynthian")
		zsys_dir = os.environ.get('ZYNTHIAN_SYS_DIR',"/zynthian/zynthian-sys")
		zconfig_dir = os.environ.get('ZYNTHIAN_CONFIG_DIR',"/zynthian/config")
		
		check_output("cp -a '{}/config/zynthian_envars_{}.sh' '{}/zynthian_envars.sh'".format(zsys_dir, config_name, zconfig_dir), shell=True)
		check_output("{}/scripts/update_zynthian_sys.sh".format(zsys_dir), shell=True)
		check_output("rm -rf {}/zyncoder/build".format(zyn_dir), shell=True)
		check_output("rm -rf {}/img".format(zsys_dir), shell=True)
		check_output("reboot", shell=True)
	else:
		print("Zynthian already configured for {}.".format(config_name))
else:
	print("Autoconfig for this HW footprint is not available.")

#--------------------------------------------------------------------

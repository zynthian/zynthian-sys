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
import zynthian_autoconfig

# --------------------------------------------------------------------

if len(sys.argv) > 1:
	board_names = sys.argv[1]
else:
	board_names = None

kit_name = os.environ.get('ZYNTHIAN_KIT_VERSION')
print(f"Configured Kit: {kit_name}")


# Select boards to test
if board_names:
	board_names = [s.strip() for s in board_names.split(',')]
elif kit_name:
	board_names = []
	for bname in zynthian_autoconfig.hardware_config.keys():
		if bname.startswith(kit_name):
			board_names.append(bname)

# Check chip presence for selected boards
if len(board_names) > 0:
	zynthian_autoconfig.check_boards(board_names)
else:
	print("ERROR: Not specified any hardware to detect!")

# --------------------------------------------------------------------

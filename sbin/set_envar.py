#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: update_envars.py
# 
# Update $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh with the 
# file given as first argument 
# 
# Copyright (C) 2015-2020 Fernando Moyano <jofemodo@zynthian.org>
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

sys.path.append(os.environ.get('ZYNTHIAN_UI_DIR', "/zynthian/zynthian-ui"))
import zynconf

# --------------------------------------------------------------------

envar_name = sys.argv[1]
envar_value = sys.argv[2]

# Update Config
zynconf.save_config({ 
	envar_name: envar_value
})

# --------------------------------------------------------------------

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

import zynconf
import os
import sys
import shutil

sys.path.append(os.environ.get('ZYNTHIAN_UI_DIR', "/zynthian/zynthian-ui"))

# --------------------------------------------------------------------

input_envars_file = sys.argv[1]z
envars_file = "{}/zynthian_envars.sh".format(
    os.environ.get('ZYNTHIAN_CONFIG_DIR', "/zynthian/config"))
envars_backup_file = "{}/zynthian_envars_backup.sh".format(
    os.environ.get('ZYNTHIAN_CONFIG_DIR', "/zynthian/config"))

if os.path.isfile(input_envars_file):
    try:
        print("Loading config input file '{}' ...".format(input_envars_file))
        config = zynconf.load_config(False, input_envars_file)
    except Exception as e:
        print("ERROR: Config input file {} can't be parsed. Check the syntax! => \n{}".format(
            input_envars_file, e))
    try:
        print("Saving config backup '{}' ...".format(envars_backup_file))
        shutil.copyfile(envars_file, envars_backup_file)
    except Exception as e:
        print("ERROR: Can't perform a config backup! => \n{}".format(e))
    try:
        print("Updating config on '{}' ...".format(envars_file))
        zynconf.save_config(config, True)
    except Exception as e:
        print("ERROR: Config can't be updated! => \n{}".format(e))
    try:
        print("Deleting config input file '{}' ...".format(input_envars_file))
        os.remove(input_envars_file)
    except Exception as e:
        print("ERROR: Input config file can't be removed! => \n{}".format(e))
else:
    print("Config input file '{}' doesn't exist.".format(update_envars_file))

# --------------------------------------------------------------------

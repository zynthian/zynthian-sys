#!/usr/bin/python3
# -*- coding: utf-8 -*-
#********************************************************************
# ZYNTHIAN PROJECT: update_envars.py
# 
# Update $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh with the 
# file given as first argument 
# 
# Copyright (C) 2015-2020 Fernando Moyano <jofemodo@zynthian.org>
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
import sys

sys.path.append(os.environ.get('ZYNTHIAN_UI_DIR',"/zynthian/zynthian-ui"))
import zynconf

#--------------------------------------------------------------------

soundcard_mixer_0 = os.environ.get('SOUNDCARD_MIXER')

if soundcard_mixer_0 is not None:
	ctrls_0 = soundcard_mixer_0.split(',')

	if len(ctrls_0) > 0:
		ctrls_1 = []
		for ctrl in ctrls_0:
			ctrl = ctrl.strip()
			if ctrl in ("Digital", "Master", "Capture", "DAC", "Speaker", "Mic", "HDMI"):
				ctrls_1.append(ctrl + " Left")
				ctrls_1.append(ctrl + " Right")
			elif ctrl in ("ADC", "ADC Right", "ADC Left"):
				pass
			else:
				ctrls_1.append(ctrl)
		soundcard_mixer_1 = ",".join(ctrls_1)

		# Update Config
		if soundcard_mixer_1 != soundcard_mixer_0:
			print("Updating SOUNDCARD_MIXER => {}".format(soundcard_mixer_1))
			zynconf.save_config({ 
				'SOUNDCARD_MIXER': soundcard_mixer_1
			})
		else:
			print("SOUNDCARD_MIXER is OK")

#--------------------------------------------------------------------

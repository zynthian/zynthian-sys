#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: generate_lv2_presets_VirtualJV.py
# 
# Generate LV2 bank/presets for VirtualVJ from included preset assignment
# 
# Copyright (C) 2025 Holger Wirtz <holger@zynthian.org>
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
import json
import re
import glob

rom_dir = "/root/.config/JV880"
jv800_manifest_file="/zynthian/zynthian-plugins/lv2/jv880.lv2/manifest.ttl"
preset_url="https://github.com/giulioz/jv880_juce.git:preset"

rom_bank={}
rom_bank['JV880 Factory Internal']=(1,65)
rom_bank['JV880 Factory A']=(66,130)
rom_bank['JV880 Factory B']=(131,195)
rom_bank['RD500 Factory']=(196,390)
rom_bank['Exp 01 Pop']=(391,535)
rom_bank['Exp 02 Orchestral']=(536,790)
rom_bank['Exp 03 Piano']=(791,901)
rom_bank['Exp 04 Vintage Synth']=(902,1156)
rom_bank['Exp 05 World']=(1157,1412)
rom_bank['Exp 06 Dance']=(1413,1671)
rom_bank['Exp 07 Super Sound Set']=(1672,1895)
rom_bank['Exp 08 60s/70s Keyboards']=(1896,2150)
rom_bank['Exp 09 Session']=(2151,2354)
rom_bank['Exp 10 Bass & Drum']=(2355,2555)
rom_bank['Exp 11 Techno']=(2556,2814)
rom_bank['Exp 12 Hip-Hop']=(2815,3073)
rom_bank['Exp 13 Vocal']=(3074,3201)
rom_bank['Exp 14 Asia']=(3202,3373)
rom_bank['Exp 15 Special FX']=(3374,3581)
rom_bank['Exp 16 Orchestral II']=(3582,3799)
rom_bank['Exp 17 Country']=(3800,4013)
rom_bank['Exp 18 Latin']=(4014,4220)
rom_bank['Exp 19 House']=(4221,4380)

with open(jv800_manifest_file, "r") as ttl_file:
    manifest = ttl_file.read()

presets = {}
preset_id=None
for line in manifest.splitlines():
    match = re.search(r'<https://github.com/giulioz/jv880_juce.git:preset(\d+)>', line)
    if match:
        preset_id = match.group(1)
    match = re.search(r'rdfs:label "([^"]+)"', line)
    if preset_id and match:
        name = match.group(1).strip()
        presets[preset_id] = {'preset': name}

result = {}
for bank, preset_range in rom_bank.items():
    result[bank] = {
        "bank_url": "None",
        "presets": []
    }
    for preset_id in range(min(preset_range), max(preset_range) + 1):
        preset = presets[str(preset_id)]
        preset_url_suffix = str(preset_id).zfill(3)
        result[bank]["presets"].append({
            "label": preset["preset"],
            "url": f"{preset_url}{preset_url_suffix}"
        })

#json_objekt = json.dumps(result, indent=4)
json_objekt = json.dumps(result)
print(json_objekt)

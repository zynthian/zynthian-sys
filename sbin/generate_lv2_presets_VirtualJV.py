#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: generate_lv2_presets_VirtualJV.py
# 
# Generate improved LV2 bank/presets TTL for VirtualVJ
# 
# Copyright (C) 2025 Holger Wirtz <holger@zynthian.org>,
#                    Jofemodo <fernando@zynthian.org>
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
import re
import glob
from subprocess import check_output

plugin_dir = "/zynthian/zynthian-plugins/lv2/jv880.lv2/"

bank_ttl_header = """@prefix lv2:   <http://lv2plug.in/ns/lv2core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix pset:  <http://lv2plug.in/ns/ext/presets#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .\n\n"""

preset_ttl_header = """@prefix lv2:   <http://lv2plug.in/ns/lv2core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix pset:  <http://lv2plug.in/ns/ext/presets#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .\n\n"""

bank_ttl_template = """<https://github.com/giulioz/jv880_juce.git:bank_{}>
    a pset:Bank ;
    lv2:appliesTo <https://github.com/giulioz/jv880_juce.git> ;
    rdfs:label \"{}\" .\n\n"""

preset_ttl_template = """<https://github.com/giulioz/jv880_juce.git:preset_{}>
    pset:bank <https://github.com/giulioz/jv880_juce.git:bank_{}> ;
    a pset:Preset ;
    lv2:appliesTo <https://github.com/giulioz/jv880_juce.git> ;
    rdfs:label "{}" ;
    state:state [ <https://github.com/giulioz/jv880_juce.git:Program> "{}"^^xsd:int ; ] .\n\n"""

rom_info = {
    "jv880_nvram.bin":  ["32K", "d2bc039f4e9748f2aa72db0dc8822591c53d580f", 65, "JV880 Factory Internal"],
    "jv880_rom1.bin": ["32K", "6c1b59905b361ac3c4803d39589406bc3e1d0647", 0,  None],
    "jv880_rom2.bin": ["256K", "282116e8e8471053cf159d22675931592b7f7c8f", 0, None],
    "jv880_waverom1.bin": ["2M", "37e28498351fb502f6d43398d288a026c02b446d", 65, "JV880 Factory A"],
    "jv880_waverom2.bin": ["2M", "963ce75b6668dab377d3a2fd895630a745491be5", 65, "JV880 Factory B"],
    "rd500_patches.bin": ["128K", "7cabda023e41a8fe4398074457bd85d6732e9914", 0, None],
    "rd500_expansion.bin": ["8M", "c81b491c8536298470f5444dd4cdd45c2c93c6f2", 195, "RD500 Factory"],
    "SR-JV80-01 Pop - CS 0x3F1CF705.bin": ["8M", "aeb02a1af5031194c723030b133fda6bfb5463f6", 145, "XP-01 Pop"],
    "SR-JV80-02 Orchestral - CS 0x3F0E09E2.BIN": ["8M", "6f8e3113e7f53b0df1f7f0bd9a0627cc655a6a1c", 255, "XP-02 Orchestral"],
    "SR-JV80-03 Piano - CS 0x3F8DB303.bin": ["8M", "899b68001674b92d82ad86dfb69c62365e368284", 111, "XP-03 Piano"],
    "SR-JV80-04 Vintage Synth - CS 0x3E23B90C.BIN": ["8M", "29fe6c1dde042ff2147c73f1c9d5fcf58092879a", 255, "XP-04 Vintage Synth"],
    "SR-JV80-05 World - CS 0x3E8E8A0D.bin": ["8M", "c0a64d6ab04fac96ceba09becd4be888304c72a6", 256, "XP-05 World"],
    "SR-JV80-06 Dance - CS 0x3EC462E0.bin": ["8M", "e2bed925027ed2f73e15aba3c46bf951c93a0716", 259, "XP-06 Dance"],
    "SR-JV80-07 Super Sound Set - CS 0x3F1EE208.bin": ["8M", "be45e76154cee6571e7bacb5633b21945b055843", 224, "XP-07 Super Sound Set"],
    "SR-JV80-08 Keyboards of the 60s and 70s - CS 0x3F1E3F0A.BIN": ["8M", "9652aa26ed091c11d3a89449e8feba5ab73b4bc7", 255, "XP-08 60s/70s Keyboards"],
    "SR-JV80-09 Session - CS 0x3F381791.BIN": ["8M", "50e67516a0c996b9813dfdac6c1d08709057e405", 204, "XP-09 Session"],
    "SR-JV80-10 Bass & Drum - CS 0x3D83D02A.BIN": ["8M", "0719e32f001d012769cc92b5dc1ea75882fa0656", 201, "XP-10 Bass & Drum"],
    "SR-JV80-11 Techno - CS 0x3F046250.bin": ["8M", "880d032b9b2ae97869358161b427c6c8d529f2f8", 259, "XP-11 Techno"],
    "SR-JV80-12 HipHop - CS 0x3EA08A19.BIN": ["8M", "d3d4ff39659bbe993cf6582c145d0db1f1e79b26", 259, "XP-12 Hip-Hop"],
    "SR-JV80-13 Vocal - CS 0x3ECE78AA.bin": ["8M", "6fd05df901127291e0b74304038ccea79c9a8812", 128, "XP-13 Vocal"],
    "SR-JV80-14 Asia - CS 0x3C8A1582.bin": ["8M", "4127864976393052f74fddf9e0a3bbe27f9324df", 172, "XP-14 Asia"],
    "SR-JV80-15 Special FX - CS 0x3F591CE4.bin": ["8M", "54b898f76e698e7bafbf093d616ad2df4df6dc82", 208, "XP-15 Special FX"],
    "SR-JV80-16 Orchestral II - CS 0x3F35B03B.bin": ["8M", "216cde7393d5fd57cabe4c2d4bbc5f65f0c07e90", 218, "XP-16 Orchestral II"],
    "SR-JV80-17 Country - CS 0x3ED75089.bin": ["8M", "07eaf0a7f822d8369c33b77a9fe2f2a3ea2f7713", 214, "XP-17 Country"],
    "SR-JV80-18 Latin - CS 0x3EA51033.BIN": ["8M", "bb177db61f6f32d7bcc693e4c23d162a3ade3801", 207, "XP-18 Latin"],
    "SR-JV80-19 House - CS 0x3E330C41.BIN": ["8M", "23ce90ce898ef59a6268070644ab18c7b7834509", 160, "XP-19 House"],
    "Custom.bin": ["8M", None, 0, "User"]
}


# -----------------------------------------------------------------------------

installed_rom_files = []

# Detect ROM files
for fname, info in rom_info.items():
    fpath = f"/root/.config/JV880/{fname}"
    if os.path.isfile(fpath):
        print(f"Detected ROM file '{fname}'...")
        try:
            sha1 = check_output(f"sha1sum \"{fpath}\"", shell=True).decode("utf-8").split(" ")[0].strip()
            if info[1] == sha1:
                print(f"\tSHA1 hash is OK! => {sha1}")
                installed_rom_files.append(fname)
            else:
                pass
                print(f"\tSHA1 hash is wrong ({sha1})! => Skipping ROM file!")
        except Exception as e:
            print(f"\tERROR while detecting ROM file '{fname}' => {e}")

# Load preset_names
with open(f"{plugin_dir}/preset_names.txt", "r") as fd:
    preset_names = fd.readlines()

# Generate LV2 banks & presets
bank_id = 1
preset_id = 1
preset_index = 0
banks_ttl_output = bank_ttl_header
presets_ttl_output = preset_ttl_header
for rfname, rinfo in rom_info.items():
    # Skip not installed banks & presets
    if rfname not in installed_rom_files or rinfo[2] == 0:
        preset_index += rinfo[2]
        continue
    bank_label = rinfo[3]
    print(f"Generating Bank '{bank_label}' ({bank_id}) => {rinfo[2]} presets")
    bank_ttl = bank_ttl_template.format(bank_id, bank_label)
    banks_ttl_output += bank_ttl
    # Generate presets for this bank:
    for i in range(rinfo[2]):
        preset_label = preset_names[preset_index].strip()
        if preset_label[0] != "#":
            #print(f"Generating Preset '{preset_label}' ({preset_id}, {i + 1}/{rinfo[2]}) => {preset_index}")
            preset_ttl = preset_ttl_template.format(preset_id, bank_id, preset_label, preset_id - 1)
            presets_ttl_output += preset_ttl
        preset_index += 1
        preset_id += 1
    bank_id += 1

#print(f"BANKS TTL => \n{banks_ttl_output}")
with open(f"{plugin_dir}/banks.ttl", "w") as fd:
    fd.write(banks_ttl_output)

#print(f"PRESETS TTL => \n{presets_ttl_output}")
with open(f"{plugin_dir}/presets.ttl", "w") as fd:
    fd.write(presets_ttl_output)

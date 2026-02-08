#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: generate_lv2_presets_vaporizer2.py
#
# Generate LV2 bank/presets for Vaporizer2 from installed native presets.
#
# Copyright (C) 2015-2026 Fernando Moyano <jofemodo@zynthian.org>
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
import shutil
from xml.etree import ElementTree
from subprocess import check_output


preset_dir = "/usr/share/Vaporizer2/Presets"
preset_dir_user = "/root/Documents/Vaporizer2/Presets"
presets_dpath = "/zynthian/zynthian-my-data/presets/lv2"
presets_lv2_dpath = f"{presets_dpath}/vaporizer2-presets.lv2"
plugin_uri = "https://www.vast-dynamics.com/plugins/VASTvaporizer2"

categories = {
    "AR": "Arpeggio",
    "AT": "Atmosphere",
    "BA": "Bass",
    "BR": "Brass",
    "BL": "Bells",
    "CH": "Chord",
    "DK": "Drum kit",
    "DR": "Drums",
    "DL": "Drum loop",
    "FX": "Effect",
    "GT": "Guitar",
    "IN": "Instrument",
    "KB": "Keyboard",
    "LD": "Lead",
    "MA": "Mallet",
    "OR": "Organ",
    "OC": "Orchestral",
    "PD": "Pad",
    "PN": "Piano",
    "PL": "Plucked",
    "RI": "Riser",
    "RD": "Reed",
    "ST": "String",
    "SY": "Synth",
    "SQ": "Sequence",
    "TG": "Trancegate",
    "VC": "Vocal",
    "WW": "Woodwind"
}


header_ttl = f"""@prefix lv2:  <http://lv2plug.in/ns/lv2core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix pset:  <http://lv2plug.in/ns/ext/presets#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix vap2:  <{plugin_uri}#> . \n\n"""

# ********************************************************************

banks = []
presets = []


def get_preset_info(fpath):
    try:
        tree = ElementTree.parse(fpath)
        root = tree.getroot()
        #for vap2 in root.iter("VASTvaporizer2"):
        cat = root.attrib['PatchCategory']
        name = root.attrib['PatchName']
        return (name, cat)
    except Exception as e:
        print(f"Error parsing native preset '{fpath}' => {e}")
        return None


def escape_ttl_string(text):
    return text.replace("\\", "\\\\").replace("\"", "\\\"").replace(">", "\\>")


def escape_ttl_uri(text):
    return text.replace(" ", "%20")


def create_lv2_bank(bank_name, cat):
    #n = len(banks)
    banks.append(bank_name)
    return f"""<{plugin_uri}#bank_{cat}>
    a pset:Bank ;
    lv2:appliesTo <{plugin_uri}> ;
    rdfs:label \"{escape_ttl_string(bank_name)}\" .\n\n"""


def create_lv2_preset(fpath, preset_name, cat):
    # Add +1 => Init preset is program #0
    n = len(presets) + 1
    presets.append(preset_name)
    if cat:
        bank_ttl = f"\n    pset:bank <{plugin_uri}#bank_{cat}> ;"
    return f"""<{escape_ttl_uri(fpath)}>
    a pset:Preset ;{bank_ttl}
    lv2:appliesTo <{plugin_uri}> ;
    rdfs:label \"{escape_ttl_string(preset_name)}\" ;
    state:state [ <{plugin_uri}:Program> \"{n}\"^^xsd:int ; ] .\n\n"""


def generate_preset_from_file(fpath):
    if os.path.exists(fpath):
        # Try to parse XML
        preset_info = get_preset_info(fpath)
        if preset_info:
            return create_lv2_preset(fpath, preset_info[0], preset_info[1])
        # Get name and category from file name
        else:
            parts = os.path.splitext(fpath)
            if parts[1] == ".vvp":
                parts = os.path.split(parts[0])
                preset_name = parts[1]
                words = parts[1].split(" ", 1)
                if words[0] in categories:
                    preset_cat = words[0]
                    preset_name = words[1]
                else:
                    preset_cat = None
                create_lv2_preset(fpath, preset_name, preset_cat)
            return ""
    else:
        print(f"Can't find native preset file '{fpath}'")
        return ""

# ******************************************************************************
# Main
# ******************************************************************************

# Create presets bundle dir, removing previous one
try:
    shutil.rmtree(presets_lv2_dpath)
except:
    pass
os.mkdir(presets_lv2_dpath)

# Manifest TTL file
manifest_ttl = header_ttl

# Create banks
for cat, cat_name in categories.items():
    manifest_ttl += create_lv2_bank(cat_name, cat)

print(f"Generating Vaporizer2 LV2 presets ...")

# Run for user presets
for fpath in glob.glob(os.path.join(preset_dir_user, "**/*.vvp"), recursive=True):
    manifest_ttl += generate_preset_from_file(fpath)

# Run for system (factory) presets
for fpath in glob.glob(os.path.join(preset_dir, "*.vvp")):
    manifest_ttl += generate_preset_from_file(fpath)

# Write manifest.ttl
manifest_fpath = f"{presets_lv2_dpath}/manifest.ttl"
with open(manifest_fpath, 'w') as fn:
    fn.write(manifest_ttl)

# ******************************************************************************

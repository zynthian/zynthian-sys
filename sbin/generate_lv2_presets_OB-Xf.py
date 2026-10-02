#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: generate_lv2_presets_OB-Xf.py
#
# Generate LV2 bank/presets for OB-Xf from installed native presets.
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
import glob
import shutil

preset_dir = "/usr/local/share/Surge Synth Team/OB-Xf/Patches"
#preset_dir_user = ""
presets_dpath = "/zynthian/zynthian-plugins/lv2-presets"
presets_lv2_dpath = f"{presets_dpath}/OB-Xf-presets.lv2"
plugin_uri = "urn:org.surge-synth-team.OB-Xf"

header_ttl = f"""@prefix lv2:  <http://lv2plug.in/ns/lv2core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix pset:  <http://lv2plug.in/ns/ext/presets#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix obxf:  <{plugin_uri}#> . \n\n"""

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


def create_lv2_bank(bank_name):
    cat = f"{len(banks):02}"
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

print(f"Generating LV2 presets for OB-Xf...")

for dpath in sorted(glob.glob(os.path.join(preset_dir, "*"))):
    if not os.path.isdir(dpath):
        continue
    dirname = os.path.basename(dpath)
    cat = f"{len(banks):02}"
    print(f"Bank {cat} => {dirname}")
    manifest_ttl += create_lv2_bank(dirname)
    for fpath in sorted(glob.glob(f"{preset_dir}/{dirname}/*.fxp")):
        fname = os.path.basename(fpath)
        preset_name = os.path.splitext(fname)[0]
        print(f"\tPreset => {preset_name}")
        manifest_ttl += create_lv2_preset(fpath, preset_name, cat)

# Write manifest.ttl
manifest_fpath = f"{presets_lv2_dpath}/manifest.ttl"
with open(manifest_fpath, 'w') as fn:
    fn.write(manifest_ttl)

# ******************************************************************************

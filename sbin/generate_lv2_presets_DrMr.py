#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: generate_lv2_presets_DrMr.py
# 
# Generate LV2 bank/presets for the DrMr sampler from hydrogen drumkits
# 
# Copyright (C) 2015-2025 Fernando Moyano <jofemodo@zynthian.org>
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
from subprocess import check_output

drumkit_dir = "/usr/share/drmr/drumkits"
drumkit_dir_local = "/usr/local/share/drmr/drumkits"
presets_dpath = "/zynthian/zynthian-my-data/presets/lv2"
presets_lv2_dpath = f"{presets_dpath}/DrMr_Sampler_presets.lv2"
plugin_uri = "http://github.com/nicklan/drmr"

# ********************************************************************

header_ttl = """@prefix lv2:  <http://lv2plug.in/ns/lv2core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix pset:  <http://lv2plug.in/ns/ext/presets#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix drmr:  <http://github.com/nicklan/drmr#> . \n\n"""

preset_ports_ttl = """
  lv2:port [
    lv2:symbol "base_note" ;
    pset:value 36.0
  ] , [
    lv2:symbol "gain_eight" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_eighteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_eleven" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_fifteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_five" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_four" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_fourteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_nine" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_nineteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_one" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_seven" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_seventeen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_six" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_sixteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_ten" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_thirteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_thirty" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_thirtyone" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_thirtytwo" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_three" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twelve" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twenty" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentyeight" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentyfive" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentyfour" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentynine" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentyone" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentyseven" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentysix" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentythree" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_twentytwo" ;
    pset:value 0.0
  ] , [
    lv2:symbol "gain_two" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_eight" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_eighteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_eleven" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_fifteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_five" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_four" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_fourteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_nine" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_nineteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_one" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_seven" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_seventeen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_six" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_sixteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_ten" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_thirteen" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_thirty" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_thirtyone" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_thirtytwo" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_three" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twelve" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twenty" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentyeight" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentyfive" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentyfour" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentynine" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentyone" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentyseven" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentysix" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentythree" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_twentytwo" ;
    pset:value 0.0
  ] , [
    lv2:symbol "pan_two" ;
    pset:value 0.0
  ] ;
    """

# ********************************************************************

banks = []
presets = []


def escape_ttl_string(text):
    return text.replace("\\", "\\\\").replace("\"", "\\\"").replace(">", "\\>")


def escape_ttl_uri(text):
    return text.replace(" ", "%20")


def create_lv2_bank(bank_name):
    n = len(banks)
    banks.append(bank_name)
    return f"""<{plugin_uri}#bank_{n}>
    a pset:Bank ;
    lv2:appliesTo <{plugin_uri}> ;
    rdfs:label \"{escape_ttl_string(bank_name)}\" .\n\n"""


def create_lv2_preset(preset_name, bank_num):
    presets.append(preset_name)
    return f"""<{escape_ttl_uri(preset_name)}.ttl>
    a pset:Preset ;
    pset:bank <{plugin_uri}#bank_{bank_num}> ;
    lv2:appliesTo <{plugin_uri}> ;
    rdfs:label \"{escape_ttl_string(preset_name)}\" ;
    rdfs:seeAlso <{escape_ttl_uri(preset_name)}.ttl> .\n\n"""


def create_lv2_preset_full(preset_name, drumkit_dpath):
    presets.append(preset_name)
    print(f"Generating DrMr LV2 preset {preset_name} => {drumkit_dpath}")
    return f"""<>
    a pset:Preset ;
    lv2:appliesTo <{plugin_uri}> ;
    rdfs:label \"{escape_ttl_string(preset_name)}\" ;
    {preset_ports_ttl}
    state:state [
            <{plugin_uri}#kitpath> "{escape_ttl_string(drumkit_dpath)}" ;
            <{plugin_uri}#velocitytoggle> false ;
            <{plugin_uri}#noteofftoggle> true ;
            <{plugin_uri}#zeroposition> "0"^^xsd:int
    ].\n"""


# Create presets bundle dir, removing previous one
try:
    shutil.rmtree(presets_lv2_dpath)
except:
    pass
os.mkdir(presets_lv2_dpath)

# Manifest TTL file
manifest_ttl = header_ttl
# Create banks
manifest_ttl += create_lv2_bank("User")
manifest_ttl += create_lv2_bank("System")

# Run for every hydrogen drumkit bundle
for dpath in sorted(glob.iglob(os.path.join(drumkit_dir_local, "*"))):
        if os.path.exists(f"{dpath}/drumkit.xml"):
                preset_name = os.path.basename(dpath)
                manifest_ttl += create_lv2_preset(preset_name, 0)
                with open(f"{presets_lv2_dpath}/{preset_name}.ttl", 'w') as fn:
                        ttl = header_ttl
                        ttl += create_lv2_preset_full(preset_name, dpath)
                        fn.write(ttl)
for dpath in sorted(glob.iglob(os.path.join(drumkit_dir, "*"))):
        if os.path.exists(f"{dpath}/drumkit.xml"):
                preset_name = os.path.basename(dpath)
                manifest_ttl += create_lv2_preset(preset_name, 1)
                with open(f"{presets_lv2_dpath}/{preset_name}.ttl", 'w') as fn:
                        ttl = header_ttl
                        ttl += create_lv2_preset_full(preset_name, dpath)
                        fn.write(ttl)

manifest_fpath = f"{presets_lv2_dpath}/manifest.ttl"
with open(manifest_fpath, 'w') as fn:
    fn.write(manifest_ttl)

#check_output(["regenerate_lv2_presets.sh", plugin_uri])

# --------------------------------------------------------------------

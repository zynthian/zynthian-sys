#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: generate_lv2_presets_TAL-U-NO-LX.py
# 
# Generate LV2 bank/presets for the TAL-U-NO-LX from XML preset collection
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
import re
import glob
import shutil
from subprocess import check_output
from xml.etree import ElementTree


drumkit_dir = "/usr/share/drmr/drumkits"
drumkit_dir_local = "/usr/local/share/drmr/drumkits"
presets_dpath = "/zynthian/zynthian-my-data/presets/lv2"
presets_lv2_dpath = f"{presets_dpath}/fabla_hydrogen_presets.lv2"
plugin_uri = "http://www.openavproductions.com/fabla"


header_ttl = f"""@prefix lv2:  <http://lv2plug.in/ns/lv2core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix pset:  <http://lv2plug.in/ns/ext/presets#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix fabla:  <{plugin_uri}#> . \n\n"""

preset_master_ports_ttl = """
    lv2:port [
        lv2:symbol "volume" ;
        pset:value {}
    ] , [
        lv2:symbol "base_note" ;
        pset:value {}
    ] , [
        lv2:symbol "compressor_makeup" ;
        pset:value {}
    ] , [
        lv2:symbol "compressor_enable" ;
        pset:value {}
    ] , [
        lv2:symbol "compressor_ratio" ;
        pset:value {}
    ] , [
        lv2:symbol "compressor_threshold" ;
        pset:value {}
    ] , [
        lv2:symbol "compressor_attack" ;
        pset:value {}
    ] , [
        lv2:symbol "compressor_decay" ;
        pset:value {}
    ] ,"""

preset_pad_ports_ttl = """ [
        lv2:symbol "pad_gain_{}" ;
        pset:value {}
    ] , [
        lv2:symbol "pad_speed_{}" ;
        pset:value {}
    ] , [
        lv2:symbol "pad_pan_{}" ;
        pset:value {}
    ] , [
        lv2:symbol "pad_attack_{}" ;
        pset:value {}
    ] , [
        lv2:symbol "pad_decay_{}" ;
        pset:value {}
    ] , [
        lv2:symbol "pad_sustain_{}" ;
        pset:value {}
    ] , [
        lv2:symbol "pad_release_{}" ;
        pset:value {}
    ] ,"""

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


def create_lv2_preset_full(drumkit_dpath):
    ttl_ports = preset_master_ports_ttl.format("1.0", "36", "0.95", "1.0", "0.5", "0.5", "0.15", "0.3")
    ttl_state_paths = ""
    try:
        root = ElementTree.parse(drumkit_dpath + "/drumkit.xml")
    except:
        return None
    preset_name = root.find('{*}name').text
    #print(f"=> DrumKit '{name}' ...")
    xml_ilist = root.find("{*}instrumentList")
    if not xml_ilist:
        print("=> Can't find sample list!")
        return None
    else:
        xml_instrs = xml_ilist.findall("{*}instrument")
        if xml_instrs:
            print(f"=> Found {len(xml_instrs)} samples!")
        else:
            print("=> Can't parse samples from list!")
            return None
    counter = 0
    for xml_instr in xml_instrs:
        index0 = int(xml_instr.find('{*}id').text)
        #name = xml_instr.find('{*}name').text
        #print(f"=> Parsing sample '{name}' ({index0}) ...")

        # Parse Gain, Speed & Pan
        try:
            gain = float(xml_instr.find('{*}volume').text)
            try:
                gain *= float(xml_instr.find('{*}gain').text)
            except:
                pass
        except:
            gain = 1.0
        speed = 0.5
        try:
            L = float(xml_instr.find('{*}pan_L').text)
            R = float(xml_instr.find('{*}pan_R').text)
            pan = 0.5 + (R - L) / 2
        except:
            pan = 0.5
        # ADSR => TODO (convert values from hydrogen to fabla!!)
        try:
            attack = float(xml_instr.find('{*}Attack').text)
            decay = float(xml_instr.find('{*}Decay').text)
            sustain = float(xml_instr.find('{*}Sustain').text)
            release = float(xml_instr.find('{*}Release').text) / 1000
        except:
            attack = 0.0
            decay = 0.68
            sustain = 1.0
            release = 0.5
        # Generate TTL code for pad controllers
        index = index0 + 1
        ttl_ports += preset_pad_ports_ttl.format(index, gain, index, speed, index, pan,
                                                 index, attack, index, decay, index, sustain, index, release)
        # Parse Sample file
        try:
            filename = xml_instr.findall(".//{*}layer")[-1].find('{*}filename').text
        except:
            try:
                filename = xml_instr.find('{*}filename').text
            except:
                filename = ""
        if not filename or len(filename) < 5:
            #print(f"\tskipping sample => '{filename}' is too short")
            continue
        sample_path = drumkit_dpath + "/" + filename
        # Generate TTL code for pad filepath
        if os.path.isfile(sample_path):
            #print(f"\tsample => {sample_path} ...")
            ttl_state_paths += f"      <{plugin_uri}#pad_{index0}_filename> <{escape_ttl_uri(sample_path)}> ;\n"
            counter += 1
        else:
            print(f"\tskipping sample => '{sample_path}' doesn't exist")

    ttl_ports = ttl_ports[:-1] + ';'
    print(f"=> Parsed {counter} valid samples")
    return [preset_name, f"""<>
    a pset:Preset ;
    lv2:appliesTo <{plugin_uri}> ;
    rdfs:label \"{escape_ttl_string(preset_name)}\" ;
    {ttl_ports}
    state:state [
{ttl_state_paths}
    ].\n"""]


def get_bank_num(preset_name):
    preset_lower = preset_name.lower()
    if "TR909" in preset_lower or "808" in preset_lower or "TR606" in preset_lower:
        return len(banks) - 2
    for i, bank_name in enumerate(banks):
        #if re.search(f"{bank_name} ", preset_name, re.IGNORECASE):
        if bank_name.lower() in preset_lower:
            return i
    return None


def generate_preset_from_drumkit(dpath):
    if os.path.exists(f"{dpath}/drumkit.xml"):
        #preset_name = os.path.basename(dpath)
        try:
            preset_name, ttl_preset_full = create_lv2_preset_full(dpath)
        except Exception as e:
            print(f"ERROR: {e}")
            return ""
        bank_num = get_bank_num(preset_name)
        if bank_num is None:
            bank_num = len(banks) - 1
        print(f"Generating from '{dpath}' => LV2 preset '{presets_lv2_dpath}/{preset_name}.ttl', bank '{banks[bank_num]}'")
        with open(f"{presets_lv2_dpath}/{preset_name}.ttl", 'w') as fn:
            fn.write(header_ttl + ttl_preset_full)
        return create_lv2_preset(preset_name, bank_num)
    else:
        print(f"Can't find XML file for drumkit '{dpath}'")
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
manifest_ttl += create_lv2_bank("Akai")
manifest_ttl += create_lv2_bank("Alesis")
manifest_ttl += create_lv2_bank("Boss")
manifest_ttl += create_lv2_bank("Casio")
manifest_ttl += create_lv2_bank("Emu")
manifest_ttl += create_lv2_bank("Kawai")
manifest_ttl += create_lv2_bank("Korg")
manifest_ttl += create_lv2_bank("Roland")
manifest_ttl += create_lv2_bank("Other")

print(f"Generating Fabla LV2 presets from Hydrogen Drumkits...")

# Run for each hydrogen drumkit bundle in local dirs
for dpath in sorted(glob.iglob(os.path.join(drumkit_dir_local, "*"))):
    manifest_ttl += generate_preset_from_drumkit(dpath)

# Run for each hydrogen drumkit bundle in system dirs
for dpath in sorted(glob.iglob(os.path.join(drumkit_dir, "*"))):
    manifest_ttl += generate_preset_from_drumkit(dpath)

# Write manifest.ttl
manifest_fpath = f"{presets_lv2_dpath}/manifest.ttl"
with open(manifest_fpath, 'w') as fn:
    fn.write(manifest_ttl)

#check_output(["regenerate_lv2_presets.sh", plugin_uri])

# ******************************************************************************

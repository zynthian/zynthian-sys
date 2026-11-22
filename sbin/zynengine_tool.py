#!/zynthian/venv/bin/python
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: Engine tool
#
# Show, enable or disable engines (as the webconf engines page does):
# the ENABLED flag of the engine in $ZYNTHIAN_CONFIG_DIR/engine_config.json
#
#   zynengine_tool.py INFO [<engine>]
#   zynengine_tool.py ENABLE <engine> [<engine> ...]
#   zynengine_tool.py DISABLE <engine> [<engine> ...]
#
# <engine> is the engine's key (e.g. "JV/OB-Xf"), its plugin URL (e.g.
# "urn:org.surge-synth-team.OB-Xf") or its name (e.g. "OB-Xf").
#
# The UI reloads the file when it changes (no restart needed).
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
#
# ********************************************************************

import os
import sys
import json

CONFIG_FILE = os.path.join(os.environ.get("ZYNTHIAN_CONFIG_DIR", "/zynthian/config"), "engine_config.json")


def print_usage():
    print(f"Usage: {sys.argv[0]} <INFO|ENABLE|DISABLE> [<engine> ...]")
    print("  <engine>: key (e.g. JV/OB-Xf), plugin URL or name")


def find_engines(engines, ref):
    """Keys of the engines matching ref: key, URL or name (case-insensitive name)"""
    if ref in engines:
        return [ref]
    keys = [k for k, v in engines.items() if v.get("URL") == ref]
    if not keys:
        keys = [k for k, v in engines.items() if str(v.get("NAME", "")).lower() == ref.lower()]
    return keys


def info_line(key, info):
    state = "enabled " if info.get("ENABLED") else "disabled"
    return f"{state}  {key:24} {info.get('NAME', '')}  {info.get('URL', '')}"


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print_usage()
        sys.exit(1)
    cmd = sys.argv[1].upper()
    refs = sys.argv[2:]
    if cmd not in ("INFO", "ENABLE", "DISABLE") or (cmd != "INFO" and not refs):
        print_usage()
        sys.exit(1)

    try:
        with open(CONFIG_FILE) as f:
            engines = json.load(f)
    except Exception as e:
        print(f"ERROR => Can't load {CONFIG_FILE} => {e}")
        sys.exit(1)

    if cmd == "INFO" and not refs:
        for key, info in engines.items():
            print(info_line(key, info))
        sys.exit(0)

    errors = 0
    changed = False
    for ref in refs:
        keys = find_engines(engines, ref)
        if not keys:
            print(f"ERROR => Engine '{ref}' not found")
            errors += 1
            continue
        for key in keys:
            if cmd != "INFO":
                enabled = cmd == "ENABLE"
                if bool(engines[key].get("ENABLED")) != enabled:
                    engines[key]["ENABLED"] = enabled
                    changed = True
            print(info_line(key, engines[key]))

    if changed:
        try:
            # Same format as the UI (zyngine/zynthian_lv2.py: save_engines)
            with open(CONFIG_FILE, "w") as f:
                json.dump(engines, f, indent=0)
        except Exception as e:
            print(f"ERROR => Can't save {CONFIG_FILE} => {e}")
            sys.exit(1)

    sys.exit(1 if errors else 0)

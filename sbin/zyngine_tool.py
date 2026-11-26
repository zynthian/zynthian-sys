#!/zynthian/venv/bin/python
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: Engine tool
#
# Show, enable or disable engines (as the webconf engines page does):
# the ENABLED flag of the engine in $ZYNTHIAN_CONFIG_DIR/engine_config.json
#
#   zyngine_tool.py [-r] INFO [<engine>]
#   zyngine_tool.py [-r] ENABLE <engine> [<engine> ...]
#   zyngine_tool.py [-r] DISABLE <engine> [<engine> ...]
#
# <engine> is the engine's key (e.g. "JV/OB-Xf"), its plugin URL (e.g.
# "urn:org.surge-synth-team.OB-Xf") or its name (e.g. "OB-Xf").
#
# -r, --regenerate: if an engine is not in the engines DB (e.g. a plugin just
# installed), regenerate the DB (regenerate_engines_db.sh) and look again.
# New plugins are added disabled: ENABLE then enables them.
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
import subprocess

CONFIG_FILE = os.path.join(os.environ["ZYNTHIAN_CONFIG_DIR"], "engine_config.json")


def print_usage():
    print(f"Usage: {sys.argv[0]} [-r|--regenerate] <INFO|ENABLE|DISABLE> [<engine> ...]")
    print("  <engine>: key (e.g. JV/OB-Xf), plugin URL or name")
    print("  -r: regenerate the engines DB if an engine is not in it")


def load_engines():
    with open(CONFIG_FILE) as f:
        return json.load(f)


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
    args = [a for a in sys.argv[1:] if a not in ("-r", "--regenerate")]
    regenerate = len(args) < len(sys.argv) - 1
    if not args:
        print_usage()
        sys.exit(1)
    cmd = args[0].upper()
    refs = args[1:]
    if cmd not in ("INFO", "ENABLE", "DISABLE") or (cmd != "INFO" and not refs):
        print_usage()
        sys.exit(1)

    try:
        engines = load_engines()
        if regenerate and any(not find_engines(engines, ref) for ref in refs):
            print("Engine not in the engines DB: regenerating it ...")
            subprocess.run([os.path.join(os.environ["ZYNTHIAN_SYS_DIR"], "sbin", "regenerate_engines_db.sh")],
                           check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            engines = load_engines()
    except Exception as e:
        print(f"ERROR => Can't load or regenerate {CONFIG_FILE} => {e}")
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

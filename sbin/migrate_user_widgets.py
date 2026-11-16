#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: migrate_user_widgets.py
#
# One-time migration of user widgets for LV2 plugins from the old
# "zyngui/widgets_user" folder to LV2 extension bundles.
#
# Old scheme: $ZYNTHIAN_UI_DIR/zyngui/widgets_user/zynthian_widget_<pname>.py
#             where <pname> = plugin name, lowercase, spaces => "_"
# New scheme: an LV2 extension bundle declaring the widget as a
#             zyngui:widget UI of the plugin(s):
#               <dest>/<pname>-zyngui.lv2/manifest.ttl
#               <dest>/<pname>-zyngui.lv2/zynthian_widget_<pname>.py
#
# The plugin URI is taken from the engines DB (engine_config.json).
# The source files are never modified or deleted. Bundles that already
# exist are skipped, unless --force is used, so the script is safe to
# run again.
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
import sys
import json
import shutil
import argparse
from urllib.parse import quote

# --------------------------------------------------------------------

ZYNTHIAN_UI_DIR = os.environ.get('ZYNTHIAN_UI_DIR', "/zynthian/zynthian-ui")
ZYNTHIAN_CONFIG_DIR = os.environ.get('ZYNTHIAN_CONFIG_DIR', "/zynthian/config")
ZYNTHIAN_PLUGINS_DIR = os.environ.get('ZYNTHIAN_PLUGINS_DIR', "/zynthian/zynthian-plugins")

DEFAULT_SRC_DIR = f"{ZYNTHIAN_UI_DIR}/zyngui/widgets_user"
DEFAULT_DEST_DIR = f"{ZYNTHIAN_PLUGINS_DIR}/lv2-widgets"
ENGINE_DB_FILES = [
    f"{ZYNTHIAN_CONFIG_DIR}/engine_config.json",
    f"{ZYNTHIAN_CONFIG_DIR}/jalv/plugins.json"
]

WIDGET_PREFIX = "zynthian_widget_"
UI_URI_BASE = "http://zynthian.org/plugins/zyngui/user/"

MANIFEST_TEMPLATE = """\
# Zynthian widget extension bundle, migrated from {src}
# It adds a zyngui:widget UI to existing plugins; it does not declare the plugins.
@prefix ui:     <http://lv2plug.in/ns/extensions/ui#> .
@prefix zyngui: <http://zynthian.org/ns/lv2/zyngui#> .

{ui_triples}

<{ui_uri}>
	a zyngui:widget ;
	ui:binary <{module}> ;
	zyngui:apiVersion 1 .
"""

# --------------------------------------------------------------------


def log(msg):
    print(msg, flush=True)


def get_pname(name):
    """ Same transformation used by the jalv engine for user widget names """
    return name.lower().replace(" ", "_")


def load_plugin_uris_by_pname():
    """ Return {pname: [plugin_uri, ...]} for all LV2 plugins in the engines DB """
    for fpath in ENGINE_DB_FILES:
        try:
            with open(fpath) as f:
                engines = json.load(f)
        except Exception as e:
            log(f"Can't read engines DB '{fpath}' => {e}")
            continue
        res = {}
        for key, info in engines.items():
            if key.startswith("JV/") and info.get('URL') and info.get('NAME'):
                res.setdefault(get_pname(info['NAME']), []).append(info['URL'])
        log(f"Using engines DB '{fpath}' ({len(res)} LV2 plugin names)")
        return res
    return None


def valid_uri(uri):
    return not re.search(r'[\x00-\x20<>"{}|^`\\]', uri)


def migrate_widget(fpath, plugin_uris, dest_dir, force=False, dry_run=False):
    """ Create the extension bundle for a widget. Return True if created. """
    module = os.path.basename(fpath)
    pname = module[len(WIDGET_PREFIX):-3]
    bundle_name = re.sub(r'[^A-Za-z0-9_.+-]', '_', pname) + "-zyngui.lv2"
    bundle_dir = os.path.join(dest_dir, bundle_name)
    ui_uri = UI_URI_BASE + quote(pname, safe='') + "#" + quote(pname, safe='')

    if os.path.exists(bundle_dir):
        if not force:
            log(f"  SKIP '{module}': bundle '{bundle_dir}' already exists (use --force to overwrite)")
            return False
        log(f"  Overwriting existing bundle '{bundle_dir}'")

    ui_triples = "\n".join(f"<{uri}> ui:ui <{ui_uri}> ." for uri in plugin_uris)
    manifest = MANIFEST_TEMPLATE.format(src=fpath, ui_triples=ui_triples, ui_uri=ui_uri, module=module)

    log(f"  '{module}' => {bundle_dir}")
    for uri in plugin_uris:
        log(f"      for <{uri}>")
    if dry_run:
        return True

    os.makedirs(bundle_dir, exist_ok=True)
    shutil.copy2(fpath, os.path.join(bundle_dir, module))
    with open(os.path.join(bundle_dir, "manifest.ttl"), "w") as f:
        f.write(manifest)
    return True


def main():
    parser = argparse.ArgumentParser(description="Migrate zynthian user widgets to LV2 extension bundles")
    parser.add_argument("--src", default=DEFAULT_SRC_DIR, help=f"user widgets folder (default: {DEFAULT_SRC_DIR})")
    parser.add_argument("--dest", default=DEFAULT_DEST_DIR, help=f"destination LV2 folder (default: {DEFAULT_DEST_DIR})")
    parser.add_argument("--force", action="store_true", help="overwrite existing bundles")
    parser.add_argument("--dry-run", action="store_true", help="show what would be done, without writing anything")
    args = parser.parse_args()

    if not os.path.isdir(args.src):
        log(f"No user widgets folder '{args.src}'. Nothing to migrate.")
        return 0

    widgets = []
    others = []
    for fname in sorted(os.listdir(args.src)):
        fpath = os.path.join(args.src, fname)
        if fname.startswith(WIDGET_PREFIX) and fname.endswith(".py") and os.path.isfile(fpath):
            widgets.append(fpath)
        elif fname != "__pycache__":
            others.append(fname)

    if not widgets:
        log(f"No user widgets found in '{args.src}'. Nothing to migrate.")
        return 0

    plugin_uris_by_pname = load_plugin_uris_by_pname()
    if plugin_uris_by_pname is None:
        log("ERROR: No engines DB available. Can't resolve plugin URIs.")
        return 1

    log(f"Migrating {len(widgets)} user widget(s) from '{args.src}' to '{args.dest}'{' (DRY RUN)' if args.dry_run else ''} ...")
    n_ok = n_skip = n_err = 0
    for fpath in widgets:
        module = os.path.basename(fpath)
        pname = module[len(WIDGET_PREFIX):-3]
        uris = [u for u in plugin_uris_by_pname.get(pname, []) if valid_uri(u)]
        if not uris:
            log(f"  SKIP '{module}': no LV2 plugin named like '{pname}' in the engines DB")
            n_skip += 1
            continue
        try:
            if migrate_widget(fpath, uris, args.dest, args.force, args.dry_run):
                n_ok += 1
            else:
                n_skip += 1
        except Exception as e:
            log(f"  ERROR '{module}' => {e}")
            n_err += 1

    if others:
        log(f"WARNING: these files in '{args.src}' are not widgets and were NOT migrated: {', '.join(others)}")
        log("         If a widget uses them, copy them into its bundle and fix the paths in the widget code.")
    log(f"Done: {n_ok} migrated, {n_skip} skipped, {n_err} errors.")
    if n_ok and not args.dry_run:
        log(f"Make sure '{args.dest}' is in LV2_PATH and restart zynthian to use the migrated widgets.")
    return 1 if n_err else 0


if __name__ == "__main__":
    sys.exit(main())

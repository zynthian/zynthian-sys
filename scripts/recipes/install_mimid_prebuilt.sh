#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"
PLUGINS_DIR="/usr/local/lib/lv2"

rm -rf $PLUGINS_DIR/MiMi-d.lv2
rm -rf $PLUGINS_DIR/MiMi-d.presets.lv2

wget "$BASE_URL_DOWNLOAD/MiMi-d.tar.xz"
tar xfv MiMi-d.tar.xz
mv MiMi-d/MiMi-d.lv2 $PLUGINS_DIR
mv MiMi-d/MiMi-d.presets.lv2 $PLUGINS_DIR
rm -rf MiMi-d
rm -f MiMi-d.tar.xz

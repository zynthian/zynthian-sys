#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/${MACHINE_HW_NAME}"
FILENAME="MiMi-d.tar.xz"

rm -rf "/usr/local/lib/lv2/MiMi-d.lv2"
rm -rf "/usr/local/lib/lv2/MiMi-d.presets.lv2"
rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/MiMi-d.lv2"
rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2-presets/MiMi-d.presets.lv2"

wget "$BASE_URL_DOWNLOAD/$FILENAME"
tar xfv "$FILENAME"
mv "MiMi-d/MiMi-d.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"
mv "MiMi-d/MiMi-d.presets.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2-presets"
rm -rf "MiMi-d"
rm -f "$FILENAME"

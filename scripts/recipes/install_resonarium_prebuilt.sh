#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/${MACHINE_HW_NAME}"
PLUGIN="Resonarium"
FILENAME="$PLUGIN.lv2.tar.xz"

cd "$ZYNTHIAN_PLUGINS_DIR/lv2"
rm -rf "./$PLUGIN.lv2"
wget "$BASE_URL_DOWNLOAD/$FILENAME"
tar xfv "$FILENAME"
rm -f "$FILENAME"


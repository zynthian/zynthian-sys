#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

plugin_name="Ultramaster KR-106.lv2"

cd $plugins_path
rm -rf "./$plugin_name"
wget "$BASE_URL_DOWNLOAD/$plugin_name.tar.xz"
tar xfv "$plugin_name.tar.xz"
rm -f "$plugin_name.tar.xz"


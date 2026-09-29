#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
wget "$BASE_URL_DOWNLOAD/riban-lv2.tar.xz"
tar xfv riban-lv2.tar.xz
rm -rf ./riban*.lv2
mv ./riban-lv2/* .
rm -rf riban-lv2
rm -f riban-lv2.tar.xz



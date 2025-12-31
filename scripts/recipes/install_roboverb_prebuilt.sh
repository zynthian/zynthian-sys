#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path || exit
rm -rf ./Roboverb.lv2
wget "$BASE_URL_DOWNLOAD/Roboverb.lv2.tar.xz"
tar xfv Roboverb.lv2.tar.xz
rm -f Roboverb.lv2.tar.xz

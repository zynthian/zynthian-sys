#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
rm -rf ./RipplerX.lv2
wget "$BASE_URL_DOWNLOAD/RipplerX.lv2.tar.xz"
tar xfv RipplerX.lv2.tar.xz
rm -f RipplerX.lv2.tar.xz


#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path || exit
rm -rf ./CHOWTapeModel.lv2
wget "$BASE_URL_DOWNLOAD/CHOWTapeModel.lv2.tar.xz"
tar xfv CHOWTapeModel.lv2.tar.xz
rm -f CHOWTapeModel.lv2.tar.xz

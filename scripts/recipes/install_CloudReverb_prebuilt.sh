#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
rm -rf ./CloudReverb.lv2
wget "$BASE_URL_DOWNLOAD/CloudReverb.lv2.tar.xz"
tar xfv CloudReverb.lv2.tar.xz
rm -f CloudReverb.lv2.tar.xz


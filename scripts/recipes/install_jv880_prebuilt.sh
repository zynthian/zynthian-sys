#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2

rm -rf jv880.lv2
wget "$BASE_URL_DOWNLOAD/jv880.lv2.tar.xz"
tar xfv "jv880.lv2.tar.xz"
rm -f "jv880.lv2.tar.xz"

regenerate_lv2_presets.sh https://github.com/giulioz/jv880_juce.git

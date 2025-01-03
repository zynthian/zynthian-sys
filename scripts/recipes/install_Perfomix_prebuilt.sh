#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Perfomix.lv2
rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/Perfomix_Default.preset.lv2

wget "$BASE_URL_DOWNLOAD/Perfomix.tar.xz"
tar xfv Perfomix.tar.xz
mv Perfomix/Perfomix_Default.preset.lv2 $ZYNTHIAN_MY_DATA_DIR/presets/lv2
mv Perfomix/Perfomix.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
rm -rf Perfomix
rm -f Perfomix.tar.xz

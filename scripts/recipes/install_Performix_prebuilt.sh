#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Performix.lv2
rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/Perfomix_Default.preset.lv2

wget "$BASE_URL_DOWNLOAD/Performix.tar.xz"
tar xfv Performix.tar.xz
mv Performix/Perfomix_Default.preset.lv2 $ZYNTHIAN_MY_DATA_DIR/presets/lv2
mv Performix/Perfomix.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/Performix.lv2
rm -rf Performix
rm -f Performix.tar.xz

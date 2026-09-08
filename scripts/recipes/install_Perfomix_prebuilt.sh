#!/bin/bash

#BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"
BASE_URL_DOWNLOAD="https://github.com/gitnob/Perfomix/releases/download"

cd $ZYNTHIAN_PLUGINS_DIR

rm -rf ./lv2/Perfomix.lv2
rm -rf ./lv2-presets/Perfomix_Default.preset.lv2

#wget "$BASE_URL_DOWNLOAD/Perfomix.tar.xz"
wget "$BASE_URL_DOWNLOAD/v1.5/Perfomix.lv2.zip"
unzip Perfomix.lv2.zip
mv Perfomix/Perfomix_Default.preset.lv2 ./lv2-presets/
mv Perfomix/Perfomix.lv2 ./lv2
rm -rf Perfomix
rm -f Perfomix.lv2.zip

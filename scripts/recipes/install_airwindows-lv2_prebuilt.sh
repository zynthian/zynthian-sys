#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2

rm -rf "Airwindows.lv2"

wget "$BASE_URL_DOWNLOAD/Airwindows.lv2.tar.xz"
tar xfv "Airwindows.lv2.tar.xz"
rm -f "Airwindows.lv2.tar.xz"


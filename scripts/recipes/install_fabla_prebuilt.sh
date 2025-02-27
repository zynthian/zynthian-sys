#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
rm -rf fabla*.lv2
wget "$BASE_URL_DOWNLOAD/fabla.tar.xz"
tar xfv "fabla.tar.xz"
mv fabla/fabla*.lv2 .
rm -rf fabla
rm -f "fabla.tar.xz"

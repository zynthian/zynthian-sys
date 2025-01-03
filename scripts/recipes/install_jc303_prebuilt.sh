#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2

wget "$BASE_URL_DOWNLOAD/JC303.lv2.tar.xz"
tar xfv "JC303.lv2.tar.xz"
rm -f "JC303.lv2.tar.xz"

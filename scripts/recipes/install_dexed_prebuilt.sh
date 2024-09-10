#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2

wget "$BASE_URL_DOWNLOAD/dexed.lv2.tar.xz"
rm -rf dexed.lv2
tar xfv "dexed.lv2.tar.xz"
rm -f "dexed.lv2.tar.xz"


#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2

wget "$BASE_URL_DOWNLOAD/jc103.lv2.tar.xz"
tar xfv "jc103.lv2.tar.xz"
rm -f "jc103.lv2.tar.xz"

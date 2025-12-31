#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path || exit
rm -rf ./ChowCentaur.lv2
wget "$BASE_URL_DOWNLOAD/ChowCentaur.lv2.tar.xz"
tar xfv ChowCentaur.lv2.tar.xz
rm -f ChowCentaur.lv2.tar.xz

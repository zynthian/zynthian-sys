#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
rm -rf mod-mda-*.lv2
wget "$BASE_URL_DOWNLOAD/mod-mda.tar.xz"
tar xfv "mod-mda.tar.xz"
mv mod-mda/mod-mda-*.lv2 .
rm -rf mod-mda
rm -f "mod-mda.tar.xz"

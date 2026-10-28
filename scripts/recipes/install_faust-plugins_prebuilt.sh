#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
wget "$BASE_URL_DOWNLOAD/faust-plugins.tar.xz"
tar xfv "faust-plugins.tar.xz"
rm -rf granulator.lv2
rm -rf granulator_e7mac.lv2
mv  faust-plugins/*.lv2 .
rm -rf faust-plugins
rm -f "faust-plugins.tar.xz"

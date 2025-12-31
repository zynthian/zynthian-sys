#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path || exit
rm -rf ./ChowPhaserStereo.lv2
rm -rf ./ChowPhaserMono.lv2
wget "$BASE_URL_DOWNLOAD/CHOWPhaser.tar.xz"
tar xfv CHOWPhaser.tar.xz
rm -f CHOWPhaser.tar.xz
mv CHOWPhaser/ChowPhaserStereo.lv2 .
mv CHOWPhaser/ChowPhaserMono.lv2 .
rm -rf CHOWPhaser

#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
wget "$BASE_URL_DOWNLOAD/OB-Xf.tar.xz"
tar xfv OB-Xf.tar.xz
rm -f OB-Xf.tar.xz

rm -rf ./OB-Xf.lv2
mv OB-Xf/OB-Xf.lv2 .

assets_dir="/root/Documents/Surge Synth Team/OB-Xf"
if [ ! -d "$assets_dir" ]; then
	mkdir -p "$assets_dir"
fi
mv OB-Xf/assets/* "$assets_dir"

rm -rf OB-Xf

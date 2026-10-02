#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd "$plugins_path" || exit
wget "$BASE_URL_DOWNLOAD/OB-Xf.tar.xz"
tar xfv OB-Xf.tar.xz
rm -f OB-Xf.tar.xz

rm -rf ./OB-Xf.lv2
mv OB-Xf/OB-Xf.lv2 .

# Remove old wrong assets folder
assets_dir="/root/Documents/Surge Synth Team/OB-Xf"
if [ -d "$assets_dir" ]; then
	rm -rf "$assets_dir"
fi
# Create system assets dir
assets_dir="/usr/local/share/Surge Synth Team/OB-Xf"
if [ -d "$assets_dir" ]; then
	rm -rf "$assets_dir/Themes"
	rm -rf "$assets_dir/Patches"
else
	mkdir -p "$assets_dir"
fi
mv OB-Xf/assets/* "$assets_dir"

rm -rf OB-Xf

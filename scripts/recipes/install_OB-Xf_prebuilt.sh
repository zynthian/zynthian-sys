#!/bin/bash

BASE_DOWNLOAD_URL="https://github.com/surge-synthesizer/OB-Xf/releases/download/Nightly"

# Install plugin binary
FILENAME="ob-xf-Linux-ubuntu24.04-arm64-2026-09-30-b08ffb6.zip"
cd $ZYNTHIAN_PLUGINS_DIR || exit 1
wget "$BASE_DOWNLOAD_URL/$FILENAME"
if [ ! -f "$FILENAME" ]; then
    exit 1
fi
unzip "$FILENAME"
rm -rf "./lv2/OB-Xf.lv2"
mv "./obxf_products/OB-Xf.lv2" "./lv2"
mv "./obxf_products/LICENSE" "./lv2/OB-Xf.lv2"
mv "./obxf_products/Readme.txt" "./lv2/OB-Xf.lv2"
rm -rf "./obxf_products"
rm -f "$FILENAME"

# Install assets
FILENAME="ob-xf-assets-2026-09-30-b08ffb6.zip"
cd "/usr/local/share" || exit 1
wget "$BASE_DOWNLOAD_URL/$FILENAME"
if [ ! -f "$FILENAME" ]; then
    exit 1
fi
# Remove old assets
assets_dir="Surge Synth Team/OB-Xf"
if [ -d "$assets_dir" ]; then
	rm -rf "$assets_dir/Themes"
	rm -rf "$assets_dir/Patches"
fi
unzip "$FILENAME"
rm -f "$FILENAME"

#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
wget "$BASE_URL_DOWNLOAD/AutoLeveler.lv2.v012.zip"
if [ -f "AutoLeveler.lv2.v012.zip" ]; then
	rm -rf ./AutoLeveler.lv2
	unzip "AutoLeveler.lv2.v012.zip"
	rm -f "AutoLeveler.lv2.v012.zip"
fi

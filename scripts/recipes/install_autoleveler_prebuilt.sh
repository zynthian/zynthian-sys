#!/bin/bash

plugins_path="$ZYNTHIAN_PLUGINS_DIR/lv2"
BASE_URL_DOWNLOAD="https://os.zynthian.org/plugins/aarch64"

cd $plugins_path
wget "$BASE_URL_DOWNLOAD/AutoLeveler.lv2 v010.zip"
unzip "AutoLeveler.lv2 v010.zip"
rm -f "AutoLeveler.lv2 v010.zip"
if [ -d "AutoLeveler.lv2 v010" ]; then
	rm -rf ./AutoLeveler.lv2
	mv "AutoLeveler.lv2 v010/AutoLeveler.lv2" .
	rm -rf "AutoLeveler.lv2 v010"
fi

#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/dusk-audio/dusk-audio-plugins/releases/download"
PLUGIN_NAME="multi-comp"
PLUGIN_VERSION="v1.3.8"
PLUGIN_BUNDLEDIR="Multi-Comp.lv2"
DOWNLOAD_FNAME="$PLUGIN_NAME-linux-arm64.zip"
URL_DOWNLOAD="$BASE_URL_DOWNLOAD/$PLUGIN_NAME-$PLUGIN_VERSION/$DOWNLOAD_FNAME"

cd $ZYNTHIAN_PLUGINS_DIR || exit 1

rm -rf "./lv2/$PLUGIN_BUNDLEDIR"

mkdir "dusk"
cd "dusk" || exit 1
wget "$URL_DOWNLOAD"
unzip "$DOWNLOAD_FNAME"
mv LV2/* ../lv2
mv "$PLUGIN_NAME-manual.pdf" "../lv2/$PLUGIN_BUNDLEDIR"
cd ..
rm -rf "dusk"

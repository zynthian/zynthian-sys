#!/bin/bash

BASE_URL_DOWNLOAD="https://github.com/dusk-audio/dusk-audio-plugins/releases/download"
PLUGIN_NAME="sunset-circuits"
PLUGIN_VERSION="v1.0.7"
DOWNLOAD_FNAME="$PLUGIN_NAME-linux-arm64.zip"
URL_DOWNLOAD="$BASE_URL_DOWNLOAD/$PLUGIN_NAME-$PLUGIN_VERSION/$DOWNLOAD_FNAME"

cd $ZYNTHIAN_PLUGINS_DIR || exit 1

rm -rf ./lv2/$PLUGIN_NAME.lv2

mkdir "dusk"
cd "dusk" || exit 1
wget "$URL_DOWNLOAD"
unzip "$DOWNLOAD_FNAME"
mv LV2/* ../lv2
cd ..
rm -rf "dusk"

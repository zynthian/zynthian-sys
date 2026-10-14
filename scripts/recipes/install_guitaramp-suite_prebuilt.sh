#!/bin/bash

VERSION="zynthian-1.21.1"
FVERSION="zynthian-v1.21.1"
BASE_NAME="guitaramp-suite-$FVERSION-aarch64"
FILE_NAME="$BASE_NAME.tar.gz"
URL_DOWNLOAD="https://github.com/rpowell5064/guitar-amp-mod/releases/download/$VERSION/$FILE_NAME"
PLUGIN_NAME="guitaramp-suite.lv2"

cd "$ZYNTHIAN_PLUGINS_DIR/lv2" || exit 1

wget "$URL_DOWNLOAD"
tar xfv "$FILE_NAME"
rm -f "$FILE_NAME"
cd "$BASE_NAME" || exit 1

rm -rf "../$PLUGIN_NAME"
mv "$PLUGIN_NAME" ..
cp -a ./pedalboards/* "/root/.pedalboards"
cd ..
rm -rf "$BASE_NAME"


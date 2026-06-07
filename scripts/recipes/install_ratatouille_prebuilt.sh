#!/bin/bash

VERSION="v0.9.11"
BASE_URL_DOWNLOAD="https://github.com/brummer10/Ratatouille.lv2/releases/download/$VERSION/"
FILE_DOWNLOAD="Ratatouille.lv2-$VERSION-linux-arm64.tar.xz"

if [ -d "/usr/lib/lv2/Ratatouille.lv2" ]; then
    rm -rf "/usr/lib/lv2/Ratatouille.lv2"
fi

cd $ZYNTHIAN_PLUGINS_DIR/lv2
if [ -d "Ratatouille.lv2" ]; then
    rm -rf Ratatouille.lv2
fi
wget "$BASE_URL_DOWNLOAD/$FILE_DOWNLOAD"
tar xfvJ $FILE_DOWNLOAD
mv "Ratatouille.lv2-$VERSION/Ratatouille.lv2" .
rm -rf "Ratatouille.lv2-$VERSION"
rm -f $FILE_DOWNLOAD

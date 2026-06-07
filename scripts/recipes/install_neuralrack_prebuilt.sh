#!/bin/bash

VERSION="v0.3.3"
BASE_URL_DOWNLOAD="https://github.com/brummer10/NeuralRack/releases/download/$VERSION/"
FILE_DOWNLOAD="NeuralRack-$VERSION-linux-arm64.tar.xz"

cd $ZYNTHIAN_PLUGINS_DIR/lv2
if [ -d "Neuralrack.lv2" ]; then
    rm -rf Neuralrack.lv2
fi
wget "$BASE_URL_DOWNLOAD/$FILE_DOWNLOAD"
tar xfvJ $FILE_DOWNLOAD
mv "NeuralRack-$VERSION/Neuralrack.lv2" .
rm -rf "NeuralRack-$VERSION"
rm -f $FILE_DOWNLOAD

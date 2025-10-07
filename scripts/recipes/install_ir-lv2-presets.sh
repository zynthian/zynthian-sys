#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/files"

echo "Installing Impulse Reponse LV2 presets ..."

cd $ZYNTHIAN_DATA_DIR/presets/lv2/
wget "$BASE_URL_DOWNLOAD/ir-lv2-presets.tar.xz"
tar xfv "ir-lv2-presets.tar.xz"
rm -f "ir-lv2-presets.tar.xz"

# Create symlinks in IRs folder
if [ ! -d "$ZYNTHIAN_DATA_DIR/files/IRs" ]; then
	mkdir -p "$ZYNTHIAN_DATA_DIR/files/IRs"
fi
cd $ZYNTHIAN_DATA_DIR/files/IRs
ln -s $ZYNTHIAN_DATA_DIR/presets/lv2/ccgb-ir.lv2 ccgb
ln -s $ZYNTHIAN_DATA_DIR/presets/lv2/jezwells-ir.lv2 jezwells
ln -s $ZYNTHIAN_DATA_DIR/presets/lv2/l480-ir.lv2 l480
ln -s $ZYNTHIAN_DATA_DIR/presets/lv2/openairlib-ir.lv2 openairlib
ln -s $ZYNTHIAN_DATA_DIR/presets/lv2/samplicity-m7-ir.lv2 samplicity-m7
ln -s $ZYNTHIAN_DATA_DIR/presets/lv2/teufelsberg-ir.lv2 teufelsberg


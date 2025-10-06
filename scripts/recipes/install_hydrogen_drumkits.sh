#!/bin/bash

BASE_URL_DOWNLOAD="https://os.zynthian.org/files/soundfonts"

echo "Installing Hydrogen Drumkits ..."

cd $ZYNTHIAN_DATA_DIR/soundfonts
wget "$BASE_URL_DOWNLOAD/hydrogen-drumkits.tar.xz"
tar xfv "hydrogen-drumkits.tar.xz"
rm -f "hydrogen-drumkits.tar.xz"
if [ -d "hydrogen" ]; then
	rm -rf "hydrogen"
fi
mv hydrogen-drumkits hydrogen

regenerate_lv2_presets.sh http://github.com/nicklan/drmr
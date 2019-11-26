#!/bin/bash

# triceratops.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR


if [ -d "triceratops" ]; then
	rm -rf "triceratops"
fi
#git clone https://github.com/BlokasLabs/triceratops.lv2.git
git clone https://github.com/thunderox/triceratops.git
cd triceratops
sed -i -- "s/'-O2'/'-O2','-fPIC'/" wscript
./waf configure
./waf
./waf install
./waf clean
cd ..

if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/triceratops.lv2" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/triceratops.lv2"
fi
ln -s "/usr/local/lib/lv2/triceratops.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"

if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/triceratops-presets.lv2" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/triceratops-presets.lv2"
fi
ln -s "/usr/local/lib/lv2/triceratops-presets.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"

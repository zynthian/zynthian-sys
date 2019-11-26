#!/bin/bash

# LV2 port of Alsa Modular Synth
cd $ZYNTHIAN_SW_DIR

if [ -d ams-lv2 ]; then
	rm -rf ams-lv2
fi
git clone --recursive https://github.com/moddevices/ams-lv2.git
cd ams-lv2
./waf configure
./waf build
./waf install
./waf clean
cd ..

if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/mod-ams.lv2" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/mod-ams.lv2"
fi
ln -s "/usr/local/lib/lv2/mod-ams.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"

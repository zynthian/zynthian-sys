#!/bin/bash

# LV2 port of Alsa Modular Synth
cd $ZYNTHIAN_PLUGINS_SRC_DIR

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

if [ -e "$ZYNTHIAN_PLUGINS_DIR/lv2/mod-ams.lv2" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/mod-ams.lv2"
fi

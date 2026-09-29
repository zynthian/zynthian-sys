#!/bin/bash

# riban LV2 plugins
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d riban-lv2 ]; then
	rm -rf riban-lv2
fi


git clone --recursive https://github.com/riban-bw/lv2-plugins.git riban-lv2
cd riban-lv2 || exit 1
make -j 3
mv ./bin/lv2/* $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf riban-lv2


#!/bin/bash

# stereo-mixer.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "lv2-stereo-mixer" ]; then
	rm -rf "lv2-stereo-mixer"
fi

git clone https://github.com/unclechu/lv2-stereo-mixer.git
cd lv2-stereo-mixer
make
mv stereo-mixer.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
cd ..

rm -rf "lv2-stereo-mixer"

#!/bin/bash

set -x

# guitarix.lv2
#REQUIRE: liblrdf-dev libboost-system-dev libzita-convolver-dev libzita-resampler-dev fonts-roboto

#dowload, compile and install guitarix
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "guitarix" ]; then
	rm -rf "guitarix"
fi

git clone https://github.com/brummer10/guitarix.git
cd guitarix/trunk
./waf configure --no-standalone --no-lv2-gui --disable-sse --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2 --no-avahi --no-bluez --no-faust --mod-lv2
./waf build -j 3
./waf install
./waf clean
cd ../..

#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "resonarium" ]; then
	rm -rf resonarium
fi

git clone https://github.com/gabrielsoule/resonarium
cd resonarium
git submodule update --init --recursive
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target Resonarium_Instrument_LV2 -j 3
mv /root/.lv2/Resonarium.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf resonarium


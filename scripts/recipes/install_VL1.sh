#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "VL1-emulator" ]; then
	rm -rf "VL1-emulator"
fi

git clone --recursive https://github.com/linuxmao-org/VL1-emulator.git
cd VL1-emulator
make -j 3 BASE_OPTS="-O3 -ffast-math -fdata-sections -ffunction-sections"
make install
cd ..

rm -rf "VL1-emulator"

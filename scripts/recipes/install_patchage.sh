#!/bin/bash

# patchage

cd $ZYNTHIAN_SW_DIR

if [ -d "patchage" ]; then
	rm -rf "patchage"
fi

git clone https://github.com/drobilla/patchage.git
cd patchage
./meson setup build
cd build
./meson compile
./meson install
./meson clean
cd ..
rm -rf build
cd ..
#rm -rf "patchage"
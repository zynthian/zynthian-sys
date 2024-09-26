#!/bin/bash

# patchage

cd $ZYNTHIAN_SW_DIR

if [ -d "patchage" ]; then
	rm -rf "patchage"
fi

git clone https://github.com/drobilla/patchage.git
cd patchage
meson setup build
cd build
meson compile -j 3
meson install

cd ../..
rm -rf "patchage"
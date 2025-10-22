#!/bin/bash

#LV2 Standalone Plugin Host

cd $ZYNTHIAN_SW_DIR
if [ -d jalv ]; then
	rm -rf jalv
fi
git clone --recursive -b asyncli https://github.com/zynthian/jalv.git
cd jalv
meson setup build
cd build
meson compile -j 3
meson install

cd ../..
rm -rf jalv


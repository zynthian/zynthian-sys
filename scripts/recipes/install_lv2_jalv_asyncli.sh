#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d jalv_asyncli ]; then
	rm -rf jalv_asyncli
fi
git clone --recursive -b asyncli https://github.com/zynthian/jalv.git jalv_asyncli
cd jalv_asyncli
meson setup build
cd build
meson compile -j 3
#mson install

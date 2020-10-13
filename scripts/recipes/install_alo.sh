#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "alo" ]; then
	rm -rf "alo"
fi
git clone --recursive https://github.com/devcurmudgeon/alo.git
cd alo/source
make -j 3 BASE_OPTS="-O3 -ffast-math -fdata-sections -ffunction-sections"
make install
rm -rf "alo"

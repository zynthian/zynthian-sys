#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "drmr" ]; then
	rm -rf "drmr"
fi

git clone https://github.com/falkTX/drmr
cd drmr
mkdir build
cd build
cmake ..
make -j 3
make install PREFIX=/usr/local

cd ../..
rm -rf "drmr"

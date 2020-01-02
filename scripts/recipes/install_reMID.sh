#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "reMID.lv2" ]; then
	rm -rf "reMID.lv2"
fi

git clone https://github.com/ssj71/reMID.lv2.git
cd reMID.lv2
mkdir build
cd build
cmake ..
make -j 2
make install
make clean
cd ..

ln -s /usr/local/lib/lv2/remid.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2


#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "string-machine" ]; then
	rm -rf "string-machine"
fi
git clone --recursive https://github.com/jpcima/string-machine.git
cd string-machine
sed -i -- 's/\-mtune\=generic//' ./dpf/Makefile.base.mk
make -j 3
DESTDIR=$ZYNTHIAN_PLUGINS_DIR LV2DIR=/lv2 make install
make clean
cd ..
rm -rf "string-machine"

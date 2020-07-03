#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "darc.lv2" ]; then
	rm -rf "darc.lv2"
fi

export OPTIMIZATIONS=""

git clone git://github.com/x42/darc.lv2.git
cd darc.lv2
make submodules
make
make install PREFIX=/usr/local
cd ..

rm -rf "darc.lv2"

#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone --recursive https://github.com/jpcima/string-machine.git
cd string-machine
make -j 3
DESTDIR=/zynthian/zynthian-plugins LV2DIR=/lv2 make install
cd ..

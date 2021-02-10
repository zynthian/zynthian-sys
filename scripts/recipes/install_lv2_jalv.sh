#!/bin/bash

#LV2 Standalone Plugin Host

cd $ZYNTHIAN_SW_DIR
if [ -d suil ]; then
	rm -rf suil
fi
git clone --recursive https://github.com/lv2/suil.git
cd suil
./waf configure --no-qt5
./waf build
./waf install

cd $ZYNTHIAN_SW_DIR
if [ -d jalv ]; then
	rm -rf jalv
fi
git clone --recursive https://github.com/zynthian/jalv.git
cd jalv
# Building for qt4 & qt5 at same time fails, so we build it separatelly
./waf --no-qt4 configure
./waf build
./waf install
./waf --no-qt5 configure
./waf build
./waf install

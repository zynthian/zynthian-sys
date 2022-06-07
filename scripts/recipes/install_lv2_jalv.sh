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
./waf configure
./waf build
./waf install

#!/bin/bash

#LV2 Standalone Plugin Host

cd $ZYNTHIAN_SW_DIR
if [ -d suil ]; then
	rm -rf suil
fi
git clone https://github.com/lv2/suil.git
cd suil
rm -rf waflib
git clone https://github.com/drobilla/autowaf.git waflib
./waf configure --no-qt5
./waf build
./waf install

cd $ZYNTHIAN_SW_DIR
if [ -d jalv ]; then
	rm -rf jalv
fi
git clone https://github.com/zynthian/jalv.git
cd jalv
rm -rf waflib
git clone https://github.com/drobilla/autowaf.git waflib
./waf configure
./waf build
./waf install


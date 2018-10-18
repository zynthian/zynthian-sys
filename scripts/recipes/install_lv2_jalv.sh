#!/bin/bash

#LV2 Standalone Plugin Host

cd $ZYNTHIAN_SW_DIR
git clone https://github.com/drobilla/suil.git
cd suil
./waf configure
#./waf configure --no-qt5 # TODO: Re-enable QT5 support that is failing because of Cocoa 
./waf
./waf install

cd $ZYNTHIAN_SW_DIR
git clone https://github.com/zynthian/jalv.git
cd jalv
git checkout zynthian
./waf configure
./waf
./waf install


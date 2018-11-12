#!/bin/bash

# triceratops.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/BlokasLabs/triceratops.lv2.git
cd triceratops.lv2
sed -i -- "s/'-O2'/'-O2','-fPIC'/" wscript
./waf configure
./waf
./waf install
./waf clean
cd ..

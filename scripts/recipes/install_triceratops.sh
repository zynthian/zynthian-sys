#!/bin/bash

# triceratops.lv2

export CXXFLAGS="$CFLAGS -fpermissive"

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "triceratops" ]; then
	rm -rf "triceratops"
fi
#git clone https://github.com/BlokasLabs/triceratops.lv2.git
git clone https://github.com/thunderox/triceratops.git
cd triceratops
sed -i -- "s/'-O2'/'-O2','-fPIC'/" wscript
./waf configure
./waf
./waf install
./waf clean
cd ..
rm -rf "triceratops"

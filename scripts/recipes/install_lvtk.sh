#!/bin/bash

if [ -d lvtk ]; then
	rm -rf lvtk
fi

# LVTK-1
cd $ZYNTHIAN_SW_DIR
if [ -d lvtk-1 ]; then
	rm -rf lvtk-1
fi
git clone https://github.com/lvtk/lvtk.git lvtk-1
cd lvtk-1
git checkout 1.x
#./waf configure --disable-ui
./waf configure
./waf build
./waf install
./waf clean
cd ..

# LVTK-2
cd $ZYNTHIAN_SW_DIR
if [ -d lvtk-2 ]; then
	rm -rf lvtk-2
fi
git clone https://github.com/lvtk/lvtk.git lvtk-2
cd lvtk-2
#./waf configure --disable-ui
./waf configure
./waf build
./waf install
./waf clean
cd ..

cp /usr/local/lib/pkgconfig/lvtk-plugin-1.pc /usr/local/lib/pkgconfig/lvtk-plugin-2.pc

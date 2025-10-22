#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "ntk" ]; then
	rm -rf "ntk"
fi
git clone https://github.com/linuxaudio/ntk
cd ntk
./waf configure
./waf builf
./waf install
cd ..

if [ -d "openAV-Fabla" ]; then
	rm -rf "openAV-Fabla"
fi
git clone https://github.com/zynthian/openAV-Fabla
cd openAV-Fabla
git checkout morepads
cp ntk-static.pc /usr/local/lib/pkgconfig
mkdir build
cd build
cmake ..
make -j 3
make install PREFIX=/usr/local
cd ../..

rm -rf "openAV-Fabla"
rm -rf "ntk"

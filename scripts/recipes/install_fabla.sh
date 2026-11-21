#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "ntk" ]; then
	rm -rf "ntk"
fi

#git clone https://github.com/linuxaudio/ntk
#cd ntk
#./waf configure
#./waf build
#./waf install
#cd ..

apt -y remove fabla
apt -y install ntk-static
ln -sf /opt/kxstudio/lib/pkgconfig/ntk.pc /usr/local/lib/pkgconfig/ntk-static.pc

if [ -d "openAV-Fabla" ]; then
	rm -rf "openAV-Fabla"
fi
git clone https://github.com/zynthian/openAV-Fabla
cd openAV-Fabla
git checkout morepads
#cp ntk-static.pc /usr/local/lib/pkgconfig
mkdir build
cd build
cmake -DCMAKE_C_FLAGS="-fno-lto" \
      -DCMAKE_CXX_FLAGS="-fno-lto" \
      -DCMAKE_SHARED_LINKER_FLAGS="-fno-lto" \
      -DCMAKE_EXE_LINKER_FLAGS="-fno-lto" ..
#cmake ..
make -j 3
make install
cp -a /usr/local/lib/lv2/fabla.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
rm -rf /usr/local/lib/lv2/fabla.lv2
cp -a /usr/local/lib/lv2/fabla* $ZYNTHIAN_PLUGINS_DIR/lv2-presets
rm -rf /usr/local/lib/lv2/fabla*
cd ../..

rm -rf "openAV-Fabla"
#rm -rf "ntk"

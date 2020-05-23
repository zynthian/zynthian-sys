#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
sudo apt-get install --no-install-recommends --yes build-essential libcairo2-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util0-dev
git clone https://github.com/falkTX/surge.git
cd surge
git submodule update --init --recursive
premake5 --cc=gcc --os=linux gmake2
sed -i 's/config=debug_x64/config=release_armv7ve/g' surge-lv2.make
sed -i 's/-msse2/-DNEON_SSE=1/g' surge-lv2.make
CXXFLAGS=`echo $CXXFLAGS | sed 's/-munaligned-access //'` make -f surge-lv2.make 
rsync -r --delete target/lv2/Release/Surge.lv2 ${ZYNTHIAN_PLUGINS_DIR}/lv2

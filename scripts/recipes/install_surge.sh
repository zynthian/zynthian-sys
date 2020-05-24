#!/bin/bash
# https://github.com/hexdump0815/surge-arm-build
# https://github.com/nemequ/simde

cd $ZYNTHIAN_PLUGINS_SRC_DIR
sudo apt-get install --no-install-recommends --yes build-essential libcairo2-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util0-dev
git clone https://github.com/hexdump0815/surge-arm-build.git
git checkout 5add960506adc2af3a647698edb8fca3f6ef07f0 # just to be sure to use the right version!
cd surge-arm-build
git clone https://github.com/surge-synthesizer/surge.git
cd surge
git checkout release_1.6.6
git submodule update --init --recursive
patch --forward -p0 <../surge-armv7l.patch
find * -type f -exec ../simde-ify.sh {} \;
git clone https://github.com/nemequ/simde.git
sed -i 's/flags { "StaticRuntime" }/flags { staticruntime "On" }/g' premake5.lua
premake5 --cc=gcc --os=linux gmake2
sed -i '/^ifndef verbose/,+4d' surge-lv2.make
sed -i 's, -m64,,g;s,-msse2,-march=armv7-a -mfpu=vfpv3-d16 -mno-unaligned-access,g;s,FORCE_INCLUDE +=,FORCE_INCLUDE += -Isimde/simde,g' surge-*.make
CXXFLAGS="" CFLAGS="" make -f surge-lv2.make 
rsync -r --delete target/lv2/Debug/Surge.lv2 "${ZYNTHIAN_PLUGINS_DIR}/lv2"
cd ..

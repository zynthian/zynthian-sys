#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
sudo apt-get install --no-install-recommends --yes build-essential libcairo2-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util0-dev 
git clone https://github.com/falkTX/surge.git
cd surge
git submodule update --init --recursive
cp build-linux.sh build-linux-arm.sh
sed -i 's/x64/armv7ve/g' build-linux-arm.sh
sed -i "s#lv2_dest_path=\"/usr/lib/lv2\"#lv2_dest_path=\"$ZYNTHIAN_PLUGINS_DIR/lv2\"#g" build-linux-arm.sh
./build-linux-arm.sh build --project=lv2 >/dev/null 2>&1 # VERY BAD HACK!
sed -i 's/-msse2//g' surge-lv2.make
sed -i 's/^DEFINES += /DEFINES += -DNEON_SSE=1 /g' surge-lv2.make
#sed -i 's/ -lgcc_s -lgcc//g' surge-lv2.make
#sed -i 's/ -lgcc / /g' surge-lv2.make
#sed -i 's/ -fdata-sections -ffunction-sections//g' surge-lv2.make
./build-linux-arm.sh -v build --project=lv2
./build-linux-arm.sh -v install --project=lv2
./build-linux-arm.sh clean-all
cd ..

# python scripts/linux/generate-lv2-ttl.py target/lv2/Release/Surge.lv2/Surge.so

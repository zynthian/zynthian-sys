#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

# DISTRHO ports
if [ -d "DISTRHO-Ports" ]; then
	rm -rf "DISTRHO-Ports"
fi
git clone --recursive "https://github.com/DISTRHO/DISTRHO-Ports.git"
cd "DISTRHO-Ports"
meson setup build --buildtype release
ninja -C build
ninja -C build install

# Compile legacy DISTRHO libraries => needed to build extra ports!
rm -rf build
git checkout legacy
export LINUX_EMBED=true
./scripts/premake-update.sh linux
make -j 3

# Extra DISTRHO ports => We want argotlunar2.lv2!!
if [ -d "DISTRHO-Ports-Extra" ]; then
	rm -rf "DISTRHO-Ports-Extra"
fi
git clone https://github.com/DISTRHO/DISTRHO-Ports-Extra.git
cd "DISTRHO-Ports-Extra"
export LINUX_EMBED=true
./scripts/premake-update.sh linux
make -j 3 lv2
# Generate argotlunar's binary but not TTL, so we take TTL from 32bits version. It should be identical!
cd ..

rm -rf "DISTRHO-Ports-Extra"
rm -rf "DISTRHO-Ports"



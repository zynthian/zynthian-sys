#!/bin/bash
builddir=vl1
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "$builddir" ]; then
        rm -rf "$builddir"
fi
git clone --recursive https://github.com/linuxmao-org/VL1-emulator.git $builddir
cd $builddir
make -j 3 BASE_OPTS="-O3 -ffast-math -fdata-sections -ffunction-sections"
make install
rm -rf "$builddir"

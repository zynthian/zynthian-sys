#!/bin/bash

# LV2, lilv and Python bindings
cd $ZYNTHIAN_SW_DIR

if [ -d lv2 ]; then
	rm -rf lv2
fi
git clone --recursive https://github.com/lv2/lv2.git
cd lv2
meson setup build
cd build
meson compile
meson install
cd ../..

if [ -d serd ]; then
	rm -rf serd
fi
git clone --recursive https://github.com/drobilla/serd.git
cd serd
meson setup build
cd build
meson compile
meson install
cd ../..

if [ -d zix ]; then
	rm -rf zix
fi
git clone --recursive https://github.com/drobilla/zix.git
cd zix
meson setup build
cd build
meson configure -Dcpp_link_args="$CXXFLAGS -lstdc++fs"
meson compile
meson install
cd ../..

if [ -d sord ]; then
	rm -rf sord
fi
git clone --recursive https://github.com/drobilla/sord.git
cd sord
meson setup build
cd build
meson compile
meson install
cd ../..

if [ -d sratom ]; then
	rm -rf sratom
fi
git clone --recursive https://github.com/lv2/sratom.git
cd sratom
meson setup build
cd build
meson compile
meson install
cd ../..


if [ -d lilv ]; then
	rm -rf lilv
fi
git clone --recursive https://github.com/lv2/lilv.git
cd lilv
meson setup build
cd build

#Configure the python destination directory
rm -rf /usr/local/lib/python3
python_dir=`find /usr/local/lib -type d -iname python3* | head -n 1`
meson configure -Dpython.purelibdir="$python_dir/dist-packages"

meson compile
meson install
cd ../..

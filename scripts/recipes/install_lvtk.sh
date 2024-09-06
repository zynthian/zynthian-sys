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
git checkout v1
# Get a waf that works with little tweaks
cp -a /zynthian/zynthian-sys/scripts/recipes/waf .
./waf configure
sed -i "s/rU/r/g" .waf3-1.7.16-298c23e5260e502b06df5657cfb0eb26/waflib/Context.py
sed -i "s/rU/r/g" .waf3-1.7.16-298c23e5260e502b06df5657cfb0eb26/waflib/ConfigSet.py
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
git checkout v2
meson setup build
cd build
meson compile
meson install
cd ../..

# pugl: needed for v3
if [ -d pugl ]; then
	rm -rf pugl
fi
git clone https://github.com/lv2/pugl
cd pugl
meson setup build
cd build
meson compile
meson install
cd ../..

# LVTK-3
cd $ZYNTHIAN_SW_DIR
if [ -d lvtk-3 ]; then
	rm -rf lvtk-3
fi
git clone https://github.com/lvtk/lvtk.git lvtk-3
cd lvtk-3
meson setup build
cd build
meson compile
meson install
cd ../..

cp /usr/local/lib/pkgconfig/lvtk-plugin-1.pc /usr/local/lib/pkgconfig/lvtk-plugin-2.pc

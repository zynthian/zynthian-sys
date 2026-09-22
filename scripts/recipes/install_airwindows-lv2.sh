#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "airwindows-lv2" ]; then
	rm -rf airwindows-lv2
fi

git clone --recursive https://git.sr.ht/~hannes/airwindows-lv2
cd airwindows-lv2/
meson setup build
meson compile -C build
meson install -C build
mv "/usr/local/lib/aarch64-linux-gnu/lv2/Airwindows.lv2" $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf airwindows-lv2


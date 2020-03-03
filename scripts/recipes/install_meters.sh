#!/bin/bash

# meters.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "meters.lv2" ]; then
	rm -rf "meters.lv2"
fi

git clone https://github.com/x42/meters.lv2.git
cd meters.lv2
sed -i -- 's/-msse -msse2 -mfpmath=sse//' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/lib\/lv2/LV2DIR ?= \/zynthian\/zynthian-plugins\/lv2/' Makefile
make -j 4 MOD=1
make MOD=1 install
make clean
cd ..

rm -rf "meters.lv2"

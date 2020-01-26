#!/bin/bash

# fat1.lv2
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/x42/fat1.lv2.git
cd fat1.lv2
sed -i -- 's/-msse -msse2 -mfpmath=sse//' Makefile
sed -i -- 's/LV2DIR ?= \$(PREFIX)\/lib\/lv2/LV2DIR ?= \/zynthian\/zynthian-plugins\/lv2/' Makefile
make -j 4 MOD=1
make MOD=1 install
make clean
cd ..

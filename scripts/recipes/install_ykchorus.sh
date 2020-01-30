#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "ykchorus" ]; then
        rm -rf "ykchorus"
fi
git clone --recursive https://github.com/SpotlightKid/ykchorus.git
cd ykchorus
make -j 3 BASE_OPTS="-O3 -ffast-math -fdata-sections -ffunction-sections"
mkdir -p $ZYNTHIAN_PLUGINS_DIR/lv2/
cp -a bin/ykchorus.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2/
cd ..
rm -rf "ykchorus"

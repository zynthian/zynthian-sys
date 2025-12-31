#!/bin/bash

# Steps to build roboverb from source code:

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit

if [ -d "roboverb" ]; then
  rm -rf roboverb
fi

git clone https://github.com/kushview/roboverb.git
git submodule update --init --recursive --depth=1
cmake -Bbuild -GNinja
cd build || exit
ninja -j4

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Roboverb.lv2
cp -a ./build/Roboverb_artefacts/LV2/Roboverb.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit
rm -rf roboverb

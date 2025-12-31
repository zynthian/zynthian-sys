#!/bin/bash

# Steps to build CHOWPhaser from source code:

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit

if [ -d "KlonCentaur" ]; then
  rm -rf KlonCentaur
fi

git clone https://github.com/jatinchowdhury18/KlonCentaur.git
cd KlonCentaur || exit
git submodule update --init --recursive
cmake -Bbuild
cmake --build build/ --config Release -j 4

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/ChowCentaur.lv2
cp -a ./build/ChowCentaur/ChowCentaur_artefacts/LV2/ChowCentaur.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit
rm -rf KlonCentaur

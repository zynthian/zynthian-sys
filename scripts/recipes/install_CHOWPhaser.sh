#!/bin/bash

# Steps to build CHOWPhaser from source code:

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit

if [ -d "CHOWPhaser" ]; then
  rm -rf CHOWPhaser
fi
git clone https://github.com/jatinchowdhury18/CHOWPhaser.git
cd CHOWPhaser || exit
git submodule update --init --recursive
# Build just LV2 plugin
sed -i 's/FORMATS AU VST3 Standalone/FORMATS /' CMakeLists.txt
cmake -Bbuild
cmake --build build --config Release -j 4

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/ChowPhaserStereo.lv2
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/ChowPhaserMono.lv2
cp -a ./build/ChowPhaserStereo_artefacts/LV2/ChowPhaserStereo.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2
cp -a ./build/ChowPhaserMono_artefacts/LV2/ChowPhaserMono.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit
rm -rf CHOWPhaser

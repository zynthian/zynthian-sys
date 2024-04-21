#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "odin2" ]; then
    rm -rf "odin2"
fi

git clone --recursive https://github.com/TheWaveWarden/odin2
cd odin2
# Bugfix in JUCELV2 => This should be fixed upstream!!
sed -i "s/namespace juce/\#include \<utility\>\n\nnamespace juce/" libs/JUCELV2/modules/juce_gui_basics/windows/juce_ComponentPeer.h
cmake -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -D BUILD_LV2=TRUE -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local
cmake --build build --config Release
cp -a ./build/Odin2_artefacts/Release/LV2/Odin2.lv2 /usr/local/lib/lv2

cd ..
rm -rf "odin2"

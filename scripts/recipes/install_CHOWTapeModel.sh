#!/bin/bash

# Steps to build AnalogTapeModel (CHOW Tape) from source code:

# Install dependencies
#apt-get install --yes libasound2-dev libxcursor-dev libxinerama-dev libxrandr-dev libjack-jackd2-dev
apt-get -y install freeglut3-dev

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit

if [ -d "AnalogTapeModel" ]; then
  rm -rf AnalogTapeModel
fi

git clone --recursive https://github.com/jatinchowdhury18/AnalogTapeModel.git
cd "AnalogTapeModel" || exit
git submodule update --init --recursive

cd Plugin || exit
# Build just LV2 plugin
sed -i 's/FORMATS AU VST3 Standalone/FORMATS /' CMakeLists.txt
# Add "#include <utility>" to juce file to avoid "std:exchange" error
sed -i 's/namespace juce/\#include \<utility\>\n\nnamespace juce/' ./modules/JUCE/modules/juce_gui_basics/windows/juce_ComponentPeer.h

cmake -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build/ --config Release -j 4

#make install
rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/CHOWTapeModel.lv2
cp -a ./build/CHOWTapeModel_artefacts/Release/LV2/CHOWTapeModel.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd "$ZYNTHIAN_PLUGINS_SRC_DIR" || exit
rm -rf AnalogTapeModel

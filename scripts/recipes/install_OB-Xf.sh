#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "OB-Xf" ]; then
	rm -rf OB-Xf
fi

git clone https://github.com/surge-synthesizer/OB-Xf.git
cd OB-Xf
cmake -DOBXF_JUCE_FORMATS=LV2 -B Builds/Release .
echo -e "\ninclude(Builds/Release/_deps/sstplugininfra-src/cmake/git-version-functions.cmake)" >> CMakeLists.txt
cmake --build Builds/Release --config Release
mv ./Builds/Release/OB-Xf_artefacts/LV2/OB-Xf.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

assets_dir="/root/Documents/Surge Synth Team/OB-Xf"
if [ ! -d "$assets_dir" ]; then
	mkdir -p "$assets_dir"
fi
mv assets/Surge\ Synth\ Team/OB-Xf/* "$assets_dir"

cd ..
rm -rf OB-Xf


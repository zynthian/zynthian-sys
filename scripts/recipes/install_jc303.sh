#!/bin/bash

# jc103

cd $ZYNTHIAN_SW_DIR/plugins

if [ -d "jc103" ]; then
	rm -rf jc103
fi

git clone --recursive https://github.com/midilab/jc303.git
cd jc303
cmake -B build
cmake --build build --config Release
mv ./build/JC303_artefacts/LV2/JC303.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

cd ..
rm -rf jc103


#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "ADLplug" ]; then
	rm -rf "ADLplug"
fi
git clone --recursive https://github.com/jpcima/ADLplug.git
mkdir ADLplug/build
cd ADLplug/build
cmake -DCMAKE_BUILD_TYPE=Release -DADLplug_VST2=OFF -DADLplug_VST3=OFF -DADLplug_LV2=ON -DADLplug_Standalone=OFF -DADLplug_Jack=OFF ..
make -j 3
cmake --build . --target install
make clean
cd ../..
rm -rf "ADLplug"


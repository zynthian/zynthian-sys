#!/bin/bash

#apt -y install clang

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "surge" ]; then
	rm -rf "surge"
fi

wget https://github.com/surge-synthesizer/releases-xt/releases/download/1.3.1/surge-src-1.3.1.tar.gz
tar xfvz surge-src-1.3.1.tar.gz
cd surge
sed -i "s/#undef SURGE_JUCE_PRESETS/#define SURGE_JUCE_PRESETS 1/g" src/surge-xt/SurgeSynthProcessor.cpp
sed -i "s/firstThirdPartyCategory/firstUserCategory/g" src/surge-xt/SurgeSynthProcessor.cpp
cmake -Bignore/s13clang -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DSURGE_BUILD_LV2=TRUE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build ignore/s13clang --config Release --parallel 3
cmake --install ignore/s13clang

surge_xt_lv2_factory_preset_banks.sh

cd ..
rm -rf surge


#!/bin/bash

cd $ZYNTHIAN_PLUGIN_SRC_DIR

if [ -d "MoniqueMonosynth" ]; then
    rm -rf "MoniqueMonosynth"
fi

git clone --recursive https://github.com/surge-synthesizer/monique-monosynth
cd MoniqueMonosynth

cmake -Bignore/build -DBUILD_LV2=TRUE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build ignore/build --config Release --parallel 3
#cmake --install ignore/build
mv ./ignore/build/MoniqueMonosynth_artefacts/Release/LV2/MoniqueMonosynth.lv2 /usr/local/lib/lv2

lv2_factory_preset_banks_monique.sh

cd ..
rm -rf "MoniqueMonosynth"

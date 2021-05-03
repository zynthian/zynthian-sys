#!/bin/bash
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
sudo apt-get install --yes libasound2-dev libxcursor-dev libxinerama-dev libxrandr-dev freeglut3-dev libjack-jackd2-dev
git clone https://github.com/jatinchowdhury18/AnalogTapeModel.git AnalogTapeModel
cd AnalogTapeModel/Plugin
git submodule update --init --recursive
sed -i 's/\s+FORMATS AU VST3 Standalone LV2 #VST/FORMATS LV2/' CMakeLists.txt
cmake -Bbuild
cmake --build build/ --config Release
make install
make clean
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}

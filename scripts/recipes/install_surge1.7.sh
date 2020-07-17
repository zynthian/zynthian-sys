#!/bin/bash
cd $ZYNTHIAN_PLUGINS_SRC_DIR
sudo apt-get install --no-install-recommends --yes build-essential libcairo2-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util0-dev fonts-lato
git clone https://github.com/surge-synthesizer/surge.git
cd surge
git submodule update --init --recursive
cmake -Bbuild -DARM_NATIVE=native
cmake --build build --config Release --target Surge-LV2-Packaged
rsync -r --delete build/surge_products/Surge.lv2 "${ZYNTHIAN_PLUGINS_DIR}/lv2"
cd resources/data/
mkdir /usr/share/Surge
tar cf - . | ( cd /usr/share/Surge/; tar xf - )
cd ..

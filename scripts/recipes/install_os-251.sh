#!/bin/bash

# LV2 Otokusa OS-251

apt -y update
apt -y install npm

cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "OS-251" ]; then
	rm -rf OS-251
fi
git clone --recursive https://github.com/utokusa/OS-251
cd OS-251/src/jsui/
npm ci
npm run build
cd ../../
mkdir build
cd build
cmake ..
make -j 4
cp -r src/Os251_artefacts/LV2/OS-251.lv2 /zynthian/zynthian-plugins/lv2/

cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf OS-251
apt -y remove npm
apt -y autoremove
apt clean

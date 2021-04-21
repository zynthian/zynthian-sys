#!/bin/bash
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
git clone https://gitlab.com/edwillys/simsam.git simsam.lv2
cd simsam.lv2
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
mkdir ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2
cp simsam.so ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2
cd ../bundles/simsam.lv2
cp -R * ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2
cd ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2/sfz
git clone https://gitlab.com/edwillys/salamandergrandpiano.git
git clone https://gitlab.com/edwillys/francisbaconpiano.git
git clone https://gitlab.com/edwillys/SteinwaySonsModelB.git

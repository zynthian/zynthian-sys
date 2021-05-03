#!/bin/bash
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}
git clone https://gitlab.com/edwillys/simsam.git simsam.lv2
cd simsam.lv2
wget https://raw.githubusercontent.com/moddevices/mod-plugin-builder/37661ca55aa01a55337d7f5d6b27d998d5f98d17/plugins/package/simsam-labs/01_mod-tweaks.patch
patch -p1 <01_mod-tweaks.patch 
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
mkdir ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2
cp simsam.so ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2
cd ../bundles/simsam.lv2
sed -i 's/lv2:binary <\.\.\/\.\.\/build/lv2:binary <\/zynthian\/zynthian-plugins\/lv2\/simsam.lv2/' manifest.ttl
cp -R * ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2
cd ${ZYNTHIAN_DATA_DIR}/soundfonts/sfz
mkdir simsam
cd simsam
git clone https://gitlab.com/edwillys/salamandergrandpiano.git
git clone https://gitlab.com/edwillys/francisbaconpiano.git
git clone https://gitlab.com/edwillys/SteinwaySonsModelB.git
cd ${ZYNTHIAN_PLUGINS_DIR}/lv2/simsam.lv2/sfz
rm -rf salamandergrandpiano francisbaconpiano SteinwaySonsModelB
ln -s ${ZYNTHIAN_DATA_DIR}/soundfonts/sfz/simsam/salamandergrandpiano .
ln -s ${ZYNTHIAN_DATA_DIR}/soundfonts/sfz/simsam/francisbaconpiano .
ln -s ${ZYNTHIAN_DATA_DIR}/soundfonts/sfz/simsam/SteinwaySonsModelB .
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}/simsam.lv2/build
make clean
cd ${ZYNTHIAN_PLUGINS_SRC_DIR}

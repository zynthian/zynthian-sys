#!/bin/bash

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "gearmulator" ]; then
    rm -rf "gearmulator"
fi

git clone --recurse-submodules https://github.com/dsp56300/gearmulator.git
cd gearmulator
sed -i 's/http\:\/\/theusualsuspects\.lv2\./http\:\/\/theusualsuspects\.lv2\//g' ./source/juce.cmake
systemctl stop zynthian
systemctl stop zynthian-webconf
umount /tmp
cmake --preset zynthian
cmake --build --preset zynthian --target install
rm -rf /tmp/*
mount /tmp
systemctl start zynthian
systemctl start zynthian-webconf

#mv /usr/local/virusTestConsole /usr/local/bin
#mv /usr/local/start_IndiArp_BC.sh /usr/local/bin
#mv /usr/local/start_Impact__MS.sh /usr/local/bin

# Copy ROM files and then ...
rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/Osirus_*
jalv http://theusualsuspects.lv2/Osirus
regenerate_lv2_presets.sh http://theusualsuspects.lv2/Osirus

rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/OsTIrus_*
jalv http://theusualsuspects.lv2/OsTIrus
regenerate_lv2_presets.sh http://theusualsuspects.lv2/OsTIrus

#regenerate_lv2_presets.sh http://theusualsuspects.lv2/Vavra
#regenerate_lv2_presets.sh http://theusualsuspects.lv2/Xenia

cd ..
rm -rf "gearmulator"

#!/bin/bash


cd $ZYNTHIAN_PLUGINS_SRC_DIR

#Add the source download of lvtk 
git clone https://github.com/lvtk/lvtk.git
cd lvtk

#Dexed need lvtk/synth.hpp is not in the master branch but in branch 1.x
git checkout 1.x
./waf configure
./waf build
sudo ./waf install

#Dexed Makefile need lvtk-plugin-2.pc, need to rename
sudo mv /usr/local/lib/pkgconfig/lvtk-plugin-1.pc /usr/local/lib/pkgconfig/lvtk-plugin-2.pc
cd ..

git clone https://github.com/dcoredump/dexed
cd dexed
git checkout native-lv2
cd src
make
sudo make install
cd ../..



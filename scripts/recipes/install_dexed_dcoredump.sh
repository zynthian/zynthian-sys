#!/bin/bash


cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/dcoredump/dexed
cd dexed
git checkout native-lv2
cd src
make -j 3
make install
cd ../..

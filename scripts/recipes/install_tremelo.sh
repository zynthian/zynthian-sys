#!/bin/bash

# Tremelo: Amplitude Sinoidal Modulation
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/dsheeler/tremelo.lv2.git
cd tremelo.lv2
make -j 2
make install
make clean

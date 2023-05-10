#!/bin/bash

# Needs deb:
# libqt5svg5-dev

cd $ZYNTHIAN_SW_DIR

if [ -d "qmidinet" ]; then
	rm -rf "qmidinet"
fi

git clone https://github.com/rncbc/qmidinet.git
cd qmidinet
cmake -B build
cd build
make -j 3
make install
cd ../..

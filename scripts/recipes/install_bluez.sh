#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d "bluez" ]; then
	rm -rf "bluez"
fi

git clone https://github.com/zynthian/bluez.git
cd bluez
git checkout jack_midi
autoreconf -i
#./configure --enable-midi --disable-tools
./configure --enable-jackmidi
make -j 3
make install

rm -rf "bluez"

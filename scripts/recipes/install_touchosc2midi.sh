#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d "touchosc2midi" ]; then
	rm -rf "touchosc2midi"
fi

git clone https://github.com/zynthian/touchosc2midi.git
cd touchosc2midi
pip install .
cd ..

rm -rf "touchosc2midi"

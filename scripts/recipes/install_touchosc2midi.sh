#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d "touchosc2midi" ]; then
	rm -rf "touchosc2midi"
fi

git clone https://github.com/zynthian/touchosc2midi.git
# Risky try, but it seems to work
cd touchosc2midi
sed -i "s/python-rtmidi==1.0.0/python-rtmidi/" requirements.txt
sed -i "s/Cython==0.25.2/Cython/" requirements.txt
pip3 install .
cd ..

rm -rf "touchosc2midi"

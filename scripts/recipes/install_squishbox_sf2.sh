#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d "squishbox" ]; then
	rm -rf "squishbox"
fi
mkdir "squishbox"
cd "squishbox"

git clone https://github.com/albedozero/fluidpatcher
mv ./fluidpatcher/SquishBox/sf2/*sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2
rm -rf fluidpatcher

wget https://geekfunklabs.com/download/squishbox-soundfonts/?wpdmdl=646 -O squishbox_soundfonts.zip
unzip squishbox_soundfonts.zip
rm -f squishbox_soundfonts.zip
mv ./sf2/*sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2
mv ./sf2/*/*sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2
rm -rf ./sf2
rm -rf ./banks

cd ..
rm -rf "squishbox"
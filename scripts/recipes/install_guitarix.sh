#!/bin/bash

# guitarix.lv2

#REQUIRE: liblrdf-dev libboost-system-dev libzita-convolver-dev libzita-resampler-dev fonts-roboto

GUITARIX_RELEASE=0.38.1

#dowload, compile and install guitarix
cd $ZYNTHIAN_PLUGINS_SRC_DIR

#git clone https://git.code.sf.net/p/guitarix/git guitarix-git
#cd guitarix-git/trunk

wget https://downloads.sourceforge.net/project/guitarix/guitarix/guitarix2-$GUITARIX_RELEASE.tar.xz
tar xfvJ guitarix2-$GUITARIX_RELEASE.tar.xz
rm -f guitarix2-$GUITARIX_RELEASE.tar.xz
cd guitarix-$GUITARIX_RELEASE

./waf configure --no-standalone --no-lv2-gui --disable-sse --lv2dir=$ZYNTHIAN_PLUGINS_DIR/lv2 --no-avahi --no-bluez --no-faust --mod-lv2
./waf build -j 2
./waf install
./waf clean
cd ../..

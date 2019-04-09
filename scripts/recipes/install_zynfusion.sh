#!/bin/bash

apt-get install ruby rake
apt-get install libgl1-mesa-swx11

cd $ZYNTHIAN_SW_DIR
git clone https://github.com/zynaddsubfx/zyn-fusion-build
cd zyn-fusion-build
# Edit build-rpi3.rb
ruby build-rpi3.rb
tar -jxvf zyn-fusion-linux-3.0.3-patch1-rpi3-release.tar.bz2
cd zyn-fusion
bash ./install-linux.sh

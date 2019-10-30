#!/bin/bash

# install_gxdistortionplus.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf GxDistortionPlus.lv2
git clone https://github.com/brummer10/GxDistortionPlus.lv2.git
cd GxDistortionPlus.lv2/
sed -i -- 's/INSTALL_DIR = \/usr\/lib\/lv2/INSTALL_DIR = \/zynthian\/zynthian-plugins\/lv2/' Makefile
make check clean nogui mod
make install
make clean
cd ..

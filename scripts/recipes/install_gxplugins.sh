#!/bin/bash

# install_gxplugins.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf GxPlugins.lv2
git clone https://github.com/brummer10/GxPlugins.lv2.git
cd GxPlugins.lv2/
git submodule init
git submodule update
sed -i -- 's/INSTALL_DIR = \/usr\/lib\/lv2/INSTALL_DIR = \/zynthian\/zynthian-plugins\/lv2/' */Makefile

make check clean nogui mod
sudo make install
make clean
cd ..

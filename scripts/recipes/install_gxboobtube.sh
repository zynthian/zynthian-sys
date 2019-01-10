#!/bin/bash

# install_gxboobtube.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf GxBoobTube.lv2
git clone https://github.com/brummer10/GxBoobTube.lv2.git
cd GxBoobTube.lv2/
sed -i -- 's/INSTALL_DIR = \/usr\/lib\/lv2/INSTALL_DIR = \/zynthian\/zynthian-plugins\/lv2/' Makefile
make check clean nogui mod
sudo make install
make clean
cd ..

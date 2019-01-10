#!/bin/bash

# install_gxvalvecaster.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf GxValveCaster.lv2
git clone https://github.com/brummer10/GxValveCaster.lv2.git
cd GxValveCaster.lv2/
sed -i -- 's/INSTALL_DIR = \/usr\/lib\/lv2/INSTALL_DIR = \/zynthian\/zynthian-plugins\/lv2/' Makefile
make check clean nogui mod
sudo make install
make clean
cd ..

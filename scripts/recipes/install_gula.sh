#!/bin/bash

# install_gula.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf gula-plugins
git clone https://github.com/steveb/gula-plugins.git
cd gula-plugins

make all
cp -r lv2/* $ZYNTHIAN_PLUGINS_DIR/lv2/

cd ..
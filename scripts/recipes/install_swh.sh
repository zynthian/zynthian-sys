#!/bin/bash

# install_SWH
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf swh-lv2
git clone https://github.com/swh/lv2.git swh-lv2
cd swh-lv2
make
export INSTALL_DIR_REALLY=$ZYNTHIAN_PLUGINS_DIR/lv2
make install-really

cd ..

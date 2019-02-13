#!/bin/bash

# install_shiro.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
rm -rf swh-lv2
git clone https://github.com/swh/lv2.git swh-lv2
cd swh-lv2
make
INSTALL_DIR_REALLY=/zynthian/zynthian-plugins/lv2 make install-really

cd ..

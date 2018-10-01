#!/bin/bash

#OBXD presets bank
cd $ZYNTHIAN_PLUGINS_SRC_DIR
wget http://zynthian.org/download/obxd_bank.tar.bz2
tar xfvj obxd_bank.tar.bz2
cd obxd_bank
cp -a obxd $ZYNTHIAN_MY_DATA_DIR/presets/lv2/obxd.lv2
cd ..
rm -f obxd_bank.tar.bz2

#!/bin/bash

# TalentedHack LV2 plugin: Autotune
cd $ZYNTHIAN_PLUGINS_SRC_DIR
if [ -d "TalentedHack" ]; then
	rm -rf "TalentedHack"
fi

git clone https://github.com/jeremysalwen/TalentedHack.git
cd TalentedHack
make
make install
mv ~/.lv2/talentedhack.lv2 /usr/local/lib/lv2

rm -rf "TalentedHack"

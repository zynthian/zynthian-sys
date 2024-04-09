#!/bin/bash

# riban LV2 plugins
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d riban-lv2-plugins ]; then
	rm -rf riban-lv2-plugins
fi


git clone --recursive https://github.com/riban-bw/lv2-plugins.git riban-lv2-plugins
cd riban-lv2-plugins
#STABLE=12bc8b3ee06312f5feb78cc894bf78107d3e9710
#git checkout -fq "$STABLE"
make -j 3
mv bin/lv2/* /usr/local/lib/lv2
make clean

#!/bin/bash

# riban LV2 plugins
cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d riban ]; then
	rm -rf riban
fi

git clone --recursive https://github.com/riban-bw/lv2.git riban
bash $ZYNTHIAN_SYS_DIR/scripts/recipes.update/update_riban_lv2.sh

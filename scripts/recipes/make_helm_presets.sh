#!/bin/bash

# helm presets generator

cd $ZYNTHIAN_PLUGINS_SRC_DIR/helm/builds/linux/LV2
make ttl_generator
./lv2_ttl_generator $ZYNTHIAN_PLUGINS_DIR/lv2/helm.lv2/helm.so
cp -a *.ttl $ZYNTHIAN_PLUGINS_DIR/lv2/helm.lv2

rm ./lv2_ttl_generator

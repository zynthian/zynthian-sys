#!/bin/bash

source zynthian_envars.sh

# Dirty Hack to force updating the Dexed TTL !!
rm -f $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards/Dexed.pedalboard/Dexed.ttl

echo "Updating zynthian-data ..."
cd "$ZYNTHIAN_DATA_DIR"
git pull
cp -n -a $ZYNTHIAN_DATA_DIR/mod-pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards

#echo "Updating zynthian-plugins ..."
#cd "$ZYNTHIAN_PLUGINS_DIR"
#git pull

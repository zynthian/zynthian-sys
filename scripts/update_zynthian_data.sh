#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

# Dirty Hack to force updating the Dexed TTL !!
rm -f $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards/Dexed.pedalboard/Dexed.ttl

echo "Updating zynthian-data ..."
cd "$ZYNTHIAN_DATA_DIR"
git pull
cp -n -a $ZYNTHIAN_DATA_DIR/mod-pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards

#echo "Updating zynthian-plugins ..."
#cd "$ZYNTHIAN_PLUGINS_DIR"
#git pull

#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi

echo "Updating zynthian-data ..."
cd $ZYNTHIAN_DIR/zynthian-data
git pull

echo "Updating zynthian-plugins ..."
cd $ZYNTHIAN_DIR/zynthian-plugins
git pull

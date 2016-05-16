#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi

echo "Updating zynthian-data ..."
cd $ZYNTHIAN_DIR/zynthian-data
git pull

echo "Updating zynthian-plugins ..."
if [ ! -d "$ZYNTHIAN_DIR/zynthian-plugins/.git" ]; then
	cd $ZYNTHIAN_DIR
	mv zynthian-plugins zynthian-plugins.bak
	git clone https://github.com/zynthian/zynthian-plugins.git
else
	cd $ZYNTHIAN_DIR/zynthian-plugins
	git pull
fi

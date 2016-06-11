#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi

echo "Updating zynthian-data ..."
cd "$ZYNTHIAN_DIR/zynthian-data"
git pull

echo "Updating zynthian-plugins ..."
if [ ! -d "$ZYNTHIAN_DIR/zynthian-plugins/.git" ]; then
	cd $ZYNTHIAN_DIR
	mv "zynthian-plugins" "zynthian-plugins.bak"
	git clone https://github.com/zynthian/zynthian-plugins.git
else
	cd "$ZYNTHIAN_DIR/zynthian-plugins"
	git pull
fi

# to remove in the future ...
echo "Fixing directory structure ..."
if [ ! -d "$ZYNTHIAN_DIR/zynthian-data/soundfonts/gig/Pianos" ]; then
	cd "$ZYNTHIAN_DIR/zynthian-data/soundfonts/gig"
	mkdir "Pianos"
	mv *.gig "Pianos"
fi
if [ ! -d "$ZYNTHIAN_DIR/zynthian-my-data/soundfonts" ]; then
	mkdir "$ZYNTHIAN_DIR/zynthian-my-data/soundfonts"
	cd "$ZYNTHIAN_DIR/zynthian-my-data/soundfonts"
	mkdir "sfz"
	mkdir "sf2"
	mkdir "gig"
fi
if [ ! -d "$ZYNTHIAN_DIR/zynthian-my-data/zynbanks" ]; then
	mkdir "$ZYNTHIAN_DIR/zynthian-my-data/zynbanks"
fi
if [ ! -d "$ZYNTHIAN_DIR/zynthian-my-data/snapshots" ]; then
	mkdir "$ZYNTHIAN_DIR/zynthian-my-data/snapshots"
fi

#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_DIR/zynthian-sys
su pi -c git pull
./scripts/update_zynthian_sys.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
su pi -c git pull
cd build
su pi -c cmake ..
su pi -c make

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_DIR/zynthian-ui
su pi -c git pull


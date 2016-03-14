#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git pull
cd build
cmake ..
make

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_DIR/zynthian-ui
git pull

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_DIR/zynthian-sys
git pull
./scripts/update_zynthian_sys.sh

#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi

#Fix permissions => REMOVE IN THE FUTURE
sudo chown -R pi:pi $ZYNTHIAN_DIR/zynthian-sys
sudo chown -R pi:pi $ZYNTHIAN_DIR/zyncoder
sudo chown -R pi:pi $ZYNTHIAN_DIR/zynthian-ui

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_DIR/zynthian-sys
git pull
sudo ./scripts/update_zynthian_sys.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git pull
cd build
cmake ..
make

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_DIR/zynthian-ui
git pull


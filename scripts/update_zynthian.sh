#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

export REBOOT_FLAGFILE="/tmp/zynthian_reboot"
rm -f $REBOOT_FLAGFILE

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_SYS_DIR
git checkout .
git pull

cd ./scripts
./update_zynthian_sys.sh
./update_zynthian_recipes.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git checkout .
git pull
cd build
cmake ..
make

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_UI_DIR
git checkout .
git pull

echo "Updating zynthian-webconf ..."
cd $ZYNTHIAN_DIR/zynthian-webconf
git checkout .
git pull | grep -q -v 'Already up-to-date.' && changed=1
if [[ "$changed" -eq 1 ]]; then
	systemctl stop zynthian-webconf
	systemctl start zynthian-webconf
fi

if [ -f $REBOOT_FLAGFILE ]; then
	rm -f $REBOOT_FLAGFILE
	reboot
fi

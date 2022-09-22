#!/bin/bash

BOOT_CONFIG_FILE="/boot/zynthian_envars.sh"

# If "zynthian_envars.sh" exist on "/boot" directory, update zynthian config with it ...
if [ -f $BOOT_CONFIG_FILE ]; then
	echo "Found On-Boot config file! Updating Zynthian config ..."
	$ZYNTHIAN_SYS_DIR/sbin/update_envars.py $BOOT_CONFIG_FILE
	$ZYNTHIAN_DIR/zyncoder/build.sh
	rm -rf $ZYNTHIAN_CONFIG_DIR/img
	rm -f $UPDATE_SYS_FLAG_FILE
	exit
fi

UPDATE_SYS_FLAG_FILE="/zynthian_update_sys"

# If flag-file does exist, call update_zynthian_sys.sh and remove flag ...
if [ -f $UPDATE_SYS_FLAG_FILE ]; then
	echo "Found Config-On-Boot flag! Updating Zynthian config ..."
	$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
	$ZYNTHIAN_DIR/zyncoder/build.sh
	rm -rf $ZYNTHIAN_CONFIG_DIR/img
	rm -f $UPDATE_SYS_FLAG_FILE
	exit
fi

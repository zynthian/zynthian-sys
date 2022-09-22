#!/bin/bash

BOOT_CONFIG_FILE="/boot/zynthian_envars.sh"
UPDATE_SYS_FLAG_FILE="/zynthian_update_sys"

function post_config() {
	rm -rf $ZYNTHIAN_DIR/zyncoder/build
	rm -rf $ZYNTHIAN_CONFIG_DIR/img
	rm -f $UPDATE_SYS_FLAG_FILE
}

# If "zynthian_envars.sh" exist on "/boot" directory, update zynthian config with it ...
if [ -f $BOOT_CONFIG_FILE ]; then
	echo "Found On-Boot config file! Updating Zynthian config ..."
	$ZYNTHIAN_SYS_DIR/sbin/update_envars.py $BOOT_CONFIG_FILE
	post_config
	exit
fi

# If flag-file does exist, call update_zynthian_sys.sh and remove flag ...
if [ -f $UPDATE_SYS_FLAG_FILE ]; then
	echo "Found Config-On-Boot flag! Updating Zynthian config ..."
	$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
	$ZYNTHIAN_SYS_DIR/sbin/zynthian_post_config.sh
	post_config
	exit
fi

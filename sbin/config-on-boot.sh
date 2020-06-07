#!/bin/bash

BOOT_CONFIG_FILE="/boot/zynthian_envars.sh"

# If "zynthian_envars.sh" exist on "/boot" directory, replace zynthian config file with it ...
if [ -f $BOOT_CONFIG_FILE ]; then
	mv -f $BOOT_CONFIG_FILE $ZYNTHIAN_CONFIG_DIR
	$ZYNTHIAN_SYS_DIR/scripts/zynthian_update_sys.sh
	exit
fi

UPDATE_SYS_FLAG_FILE="/zynthian_update_sys"

# If flag-file does exist, call zynthian_update_sys.sh and remove flag ...
if [ -f $UPDATE_SYS_FLAG_FILE ]; then
	$ZYNTHIAN_SYS_DIR/scripts/zynthian_update_sys.sh
	rm -f $UPDATE_SYS_FLAG_FILE
	exit
fi



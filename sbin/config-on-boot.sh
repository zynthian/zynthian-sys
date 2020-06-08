#!/bin/bash

UPDATE_SYS_FLAG_FILE="/zynthian_update_sys"

if [ -z "$ZYNTHIAN_CONFIG_DIR" ]; then
	echo "running /zynthian/config/zynthian_envars.sh"
	source /zynthian/config/zynthian_envars.sh
fi

# If flag-file does exist, call update_zynthian_sys.sh ...
if [ -f $UPDATE_SYS_FLAG_FILE ]; then
	echo "running update_zynthian.sys.sh after boot"
	$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
	rm -f "$UPDATE_SYS_FLAG_FILE"
fi


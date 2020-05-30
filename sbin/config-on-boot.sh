#!/bin/bash

UPDATE_SYS_FLAG_FILE="/zynthian_update_sys"

# If flag-file does exist, call zynthian_update_sys.sh ...
if [ -f $UPDATE_SYS_FLAG_FILE ]; then
	$ZYNTHIAN_SYS_DIR/scripts/zynthian_update_sys.sh
	rm -f "$UPDATE_SYS_FLAG_FILE"
fi


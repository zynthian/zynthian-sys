#!/bin/bash

UPDATE_SYS_FLAG_FILE="/zynthian_update_sys"

if [ -z "$ZYNTHIAN_CONFIG_DIR" ]; then
	echo "running /zynthian/config/zynthian_envars.sh"
	source /zynthian/config/zynthian_envars.sh
fi

BOOT_CONFIG_FILE="/boot/initial_zynthian_envars.sh"
TEMP_CONFIG_FILE="zynthian_envars.sh.tmp"
DEST_CONFIG_FILE="$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
BACKUP_CONFIG_FILE="$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh.backup"
if [ -f $BOOT_CONFIG_FILE ]; then
	echo "merging $BOOT_CONFIG_FILE with $DEST_CONFIG_FILE"
	cat $BOOT_CONFIG_FILE $DEST_CONFIG_FILE | awk -F'[=]' '{ if (a[$1]++ == 0 || $1!~/^export/ ) print $0 ; }' | awk -F'[#]' '{ if (a[$2]++ == 0 || !$2 ) print $0 ; }' > $TEMP_CONFIG_FILE
	cp $DEST_CONFIG_FILE $BACKUP_CONFIG_FILE
	mv $TEMP_CONFIG_FILE $DEST_CONFIG_FILE
	diff $DEST_CONFIG_FILE $BACKUP_CONFIG_FILE
	rm $BOOT_CONFIG_FILE
	touch $UPDATE_SYS_FLAG_FILE
fi

# If flag-file does exist, call update_zynthian_sys.sh ...
if [ -f $UPDATE_SYS_FLAG_FILE ]; then
	echo "running update_zynthian.sys.sh after boot"
	$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
	rm -f "$UPDATE_SYS_FLAG_FILE"
fi



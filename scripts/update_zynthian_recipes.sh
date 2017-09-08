#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

export REBOOT_FLAGFILE="/tmp/zynthian_reboot"
rm -f $REBOOT_FLAGFILE

echo "Updating zynthian recipes ..."
for r in $ZYNTHIAN_SYS_DIR/scripts/recipes.update/*.sh; do
	echo "Executing $r ..."
	bash $r
done

if [ -f $REBOOT_FLAGFILE ]; then
	rm -f $REBOOT_FLAGFILE
	reboot
fi

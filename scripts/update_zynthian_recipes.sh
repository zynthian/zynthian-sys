#!/bin/bash

source zynthian_envars.sh

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

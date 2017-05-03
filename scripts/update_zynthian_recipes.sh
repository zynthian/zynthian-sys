#!/bin/bash

source zynthian_envars.sh

echo "Updating zynthian recipes ..."
for r in `ls $ZYNTHIAN_SYS_DIR/scripts/recipes.update/*.sh`; do
	. $r
done

if [ "$ZYNTHIAN_REBOOT" == "1" ]; then
	reboot
fi

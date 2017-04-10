#!/bin/bash

source zynthian_envars.sh

echo "Updating zynthian recipes ..."
for r in `ls $ZYNTHIAN_SYS_DIR/scripts/recipes.update/*.sh`; do
	bash $r
done

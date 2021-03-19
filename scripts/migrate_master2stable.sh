#!/bin/bash

# One time migration: from master to stable branch

declare -a repos=('zynthian-sys' 'zyncoder' 'zynthian-ui' 'zynthian-webconf' 'zynthian-data')

## now loop through the above array
for r in "${repos[@]}"; do
	cd "$ZYNTHIAN_DIR/$r"
	if [ `git rev-parse --abbrev-ref HEAD` == 'master' ]; then
		echo "Migrating $r..."
		git fetch
		git checkout stable;
		git pull
	else
		echo "$r is already migrated!"
	fi
done


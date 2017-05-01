#!/bin/bash

if [ -f "./zynthian_envars.sh" ]; then
	source "./zynthian_envars.sh"
elif [ -z "$ZYNTHIAN_SYS_DIR" ]; then
	source "/zynthian/zynthian-sys/scripts/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_SYS_DIR
cp -fa ./scripts/zynthian_envars.sh /tmp
git checkout $ZYNTHIAN_SYS_BRANCH
git checkout .
git pull origin $ZYNTHIAN_SYS_BRANCH
cp -fa /tmp/zynthian_envars.sh ./scripts

cd ./scripts
./update_zynthian_sys.sh
./update_zynthian_recipes.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git checkout .
git pull
cd build
cmake ..
make

echo "Updating zynthian-webconf ..."
cd $ZYNTHIAN_DIR/zynthian-webconf
git checkout .
git pull

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_UI_DIR
git checkout $ZYNTHIAN_UI_BRANCH
git checkout .
git pull origin $ZYNTHIAN_UI_BRANCH
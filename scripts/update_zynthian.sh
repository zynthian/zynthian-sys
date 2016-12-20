#!/bin/bash

source zynthian_envars.sh

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_SYS_DIR
git pull origin $ZYNTHIAN_BRANCH
cd ./scripts
./update_zynthian_sys.sh
./update_zynthian_recipes.sh

echo "Updating zyncoder ..."
cd $ZYNTHIAN_DIR/zyncoder
git pull
cd build
cmake ..
make

echo "Updating zynthian-ui ..."
cd $ZYNTHIAN_UI_DIR
git pull origin $ZYNTHIAN_BRANCH


#!/bin/bash

systemctl stop zynthian

cd $ZYNTHIAN_UI_DIR
git checkout mod
git update-index --no-assume-unchanged zynthian_gui_config.py
git checkout .
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin
git checkout multilayer

cd $ZYNTHIAN_SYS_DIR
sed -i -e "s/ZYNTHIAN_UI_BRANCH\=\"mod\"/ZYNTHIAN_UI_BRANCH\=\"multilayer\"/" scripts/zynthian_envars.sh

systemctl start zynthian

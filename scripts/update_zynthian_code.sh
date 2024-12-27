#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Code
# 
# + Update the Zynthian Software from repositories.
# 
# Copyright (C) 2015-2019 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# ****************************************************************************

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------
# Pull from repositories ...
#------------------------------------------------------------------------------

echo "Updating zyncoder..."
cd $ZYNTHIAN_DIR/zyncoder
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
git checkout .
git clean -f
if [ "$RESET_ZYNTHIAN_REPOSITORIES" == "1" ]; then
	git merge --abort
	git fetch
	git reset --hard origin/$branch
	ui_changed=1
elif [[ $branch == $ZYNTHIAN_STABLE_BRANCH-* ]]; then
  echo -e "Repository 'zyncoder' frozen in tag release '$branch'!"
else
	git pull | grep -q -v 'Already up.to.date.' && ui_changed=1
fi
./build.sh

echo "Updating zynthian-ui..."
cd $ZYNTHIAN_UI_DIR
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
git checkout .
git clean -f
if [ "$RESET_ZYNTHIAN_REPOSITORIES" == "1" ]; then
	git merge --abort
	git fetch
	git reset --hard origin/$branch
	ui_changed=1
elif [[ $branch == $ZYNTHIAN_STABLE_BRANCH-* ]]; then
  echo -e "Repository 'zynthian-ui' frozen in tag release '$branch'!"
else
	git pull | grep -q -v 'Already up.to.date.' && ui_changed=1
fi
find ./zynlibs -type f -name build.sh -exec {} \;

echo "Updating zynthian-webconf..."
cd $ZYNTHIAN_DIR/zynthian-webconf
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
git checkout .
git clean -f
if [ "$RESET_ZYNTHIAN_REPOSITORIES" == "1" ]; then
	git merge --abort
	git fetch
	git reset --hard origin/$branch
	webconf_changed=1
elif [[ $branch == $ZYNTHIAN_STABLE_BRANCH-* ]]; then
  echo -e "Repository 'zynthian-webconf' frozen in tag release '$branch'!"
else
	git pull | grep -q -v 'Already up.to.date.' && webconf_changed=1
fi

cd $ZYNTHIAN_CONFIG_DIR/jalv
if [[ "$(ls -1q | wc -l)" -lt 20 ]]; then
	regenerate_engines_db.sh all
else
	regenerate_engines_db.sh engines
fi

if [[ "$ui_changed" -eq 1 ]]; then
	set_restart_ui_flag
	set_restart_webconf_flag
fi

if [[ "$webconf_changed" -eq 1 ]]; then
	set_restart_webconf_flag
fi

run_flag_actions

#------------------------------------------------------------------------------

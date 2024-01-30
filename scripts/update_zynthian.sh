#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Software
# 
# + Update the Zynthian Software from repositories.
# + Install/update extra packages (recipes).
# + Reconfigure system.
# + Reboot when needed.
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
# Pull from zynthian-sys repotory ...
#------------------------------------------------------------------------------

cd $ZYNTHIAN_SYS_DIR
export ZYNTHIAN_SYS_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "Updating zynthian-sys ($ZYNTHIAN_SYS_BRANCH)..."
git checkout .
git clean -f
if [ "$RESET_ZYNTHIAN_REPOSITORIES" == "1" ];
	git merge --abort
	git fetch
	git reset --hard origin/$ZYNTHIAN_SYS_BRANCH
else
	git pull
fi

#------------------------------------------------------------------------------
# Call update subscripts ...
#------------------------------------------------------------------------------

cd ./scripts
./update_zynthian_sys.sh
./update_zynthian_recipes.sh
./update_zynthian_data.sh
./update_zynthian_sys.sh
./update_zynthian_code.sh

run_flag_actions

echo "Update Complete."

#------------------------------------------------------------------------------

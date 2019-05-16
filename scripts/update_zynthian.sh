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

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

#------------------------------------------------------------------------------
# Reboot flag-file
#------------------------------------------------------------------------------

export REBOOT_FLAGFILE="/tmp/zynthian_reboot"
rm -f $REBOOT_FLAGFILE

#------------------------------------------------------------------------------
# Update Date/Time from network ...
#------------------------------------------------------------------------------

codebase=`lsb_release -cs`

if [ "$codebase" == "jessie" ]; then
	echo "Updating system date/time from network ..."
	htpdate -s www.pool.ntp.org wikipedia.org google.com
fi

#------------------------------------------------------------------------------
# Pull from zynthian-sys repotory ...
#------------------------------------------------------------------------------

echo "Updating zynthian-sys ..."
cd $ZYNTHIAN_SYS_DIR
git checkout .
git pull

#------------------------------------------------------------------------------
# Call update subscripts ...
#------------------------------------------------------------------------------

cd ./scripts
./update_zynthian_recipes.sh
./update_zynthian_data.sh
./update_zynthian_sys.sh
./update_zynthian_code.sh

if [ -f $REBOOT_FLAGFILE ]; then
	rm -f $REBOOT_FLAGFILE
	reboot
fi

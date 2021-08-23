#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Script for Updating a System Image (SD image)
# 
# Update an image and prepare it for repacking
# 
# Copyright (C) 2015-2021 Fernando Moyano <jofemodo@zynthian.org>
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
# 
#******************************************************************************

# Set dpkg interface
export DEBIAN_FRONTEND=noninteractive

#------------------------------------------------------------------------------
# Get System Codebase
#------------------------------------------------------------------------------

ZYNTHIAN_OS_CODEBASE=`lsb_release -cs`

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "/zynthian/config/zynthian_envars.sh"
export PATH=$PATH:/$ZYNTHIAN_SYS_DIR/scripts:/$ZYNTHIAN_SYS_DIR/sbin

#------------------------------------------------------------------------------
# Set repo branches
#------------------------------------------------------------------------------

export ZYNTHIAN_SYS_BRANCH="sfizz"
export ZYNTHIAN_UI_BRANCH="sfizz"
export ZYNTHIAN_ZYNCODER_BRANCH="testing"
export ZYNTHIAN_WEBCONF_BRANCH="testing"
export ZYNTHIAN_DATA_BRANCH="testing"

if [ $ZYNTHIAN_SYS_BRANCH ]; then
        cd $ZYNTHIAN_SYS_DIR
        git fetch
        git checkout "$ZYNTHIAN_SYS_BRANCH"
fi
if [ $ZYNTHIAN_UI_BRANCH ]; then
        cd $ZYNTHIAN_UI_DIR
        git fetch
        git checkout "$ZYNTHIAN_UI_BRANCH"
fi
if [ $ZYNTHIAN_ZYNCODER_BRANCH ]; then
        cd $ZYNTHIAN_DIR/zyncoder
        git fetch
        git checkout "$ZYNTHIAN_ZYNCODER_BRANCH"
fi
if [ $ZYNTHIAN_WEBCONF_BRANCH ]; then
        cd $ZYNTHIAN_DIR/zynthian-webconf
        git fetch
        git checkout "$ZYNTHIAN_WEBCONF_BRANCH"
fi
if [ $ZYNTHIAN_DATA_BRANCH ]; then
        cd $ZYNTHIAN_DATA_DIR
        git fetch
        git checkout "$ZYNTHIAN_DATA_BRANCH"
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

echo "UPDATING ZYNTHIAN ..."
cd ./scripts
./update_zynthian_recipes.sh
./update_zynthian_data.sh
./update_zynthian_sys.sh
./update_zynthian_code.sh

#------------------------------------------------------------------------------
# Update System ...
#------------------------------------------------------------------------------

#apt-get -y update --allow-releaseinfo-change
#apt-get -y upgrade

#------------------------------------------------------------------------------
# Adjustments ...
#------------------------------------------------------------------------------

# Copy the plugins configuration that is strangely lost
cp "$ZYNTHIAN_SYS_DIR/config/default_jalv_plugins.json" "/zynthian/config/jalv/plugins.json"

# Copy default snapshots
cp -a $ZYNTHIAN_DATA_DIR/snapshots/* $ZYNTHIAN_MY_DATA_DIR/snapshots/000

# Copy MIDI examples
cp -a $ZYNTHIAN_DATA_DIR/mid/*.mid $ZYNTHIAN_MY_DATA_DIR/capture


#------------------------------------------------------------------------------
# Update TimeStamp, clean everything and ends...
#------------------------------------------------------------------------------

# Update Build Info TimeStamp
TIMESTAMP=$(date --rfc-3339=date)
sed -i "s/^Timestamp: [0-9\-]*/Timestamp: $TIMESTAMP/" $ZYNTHIAN_DIR/build_info.txt

# Delete logs
echo "Deleting system logs ..."
for f in /var/log/* /var/log/**/* ; do
        if [ -f $f ]; then
                cat /dev/null > $f
        fi
done

# Clean history
echo "Cleaning shell history ..."
cat /dev/null > ~/.bash_history && history -c && history -w

#------------------------------------------------------------------------------
# Enable first-boot service => It's already enabled!
#------------------------------------------------------------------------------

#./set_first_boot.sh

#------------------------------------------------------------------------------

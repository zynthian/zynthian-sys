#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Install Script for MOD software
# 
# Install the MOD software
# 
# Copyright (C) 2015-2016 Fernando Moyano <jofemodo@zynthian.org>
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

source zynthian_envars.sh

#------------------------------------------------
# Install MOD stuff
#------------------------------------------------

#Define git version to use: Git commit SHAs where the local zynthian branch will be created
export MOD_HOST_GITSHA="3bda867acf68b95c05baa7366d89687cbd9e47cf"
#export MOD_UI_GITSHA="7119e2e064a7f7341c1eca32cfe19f54761dbb92" #2016-11-29 => FALLA!
#export MOD_UI_GITSHA="1d7b9d0064b0516ad922a1ea4e544a1949d63bd8" #2016-11-28 => FALLA!
#export MOD_UI_GITSHA="c3391e5f58e00a1c9737bdec6ceacb0f699611e4" #2016-11-25 => FALLA!
export MOD_UI_GITSHA="064c64a24989120731157ac27184d4b4f51ef9f2" #2016-11-25 => Last jofemodo commit => Works!!

#Install MOD-HOST
sh $ZYNTHIAN_RECIPE_DIR/install_mod-host.sh

#Install MOD-UI
sh $ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
sh $ZYNTHIAN_RECIPE_DIR/install_phantomjs.sh

#Install MOD-SDK
sh $ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh

#Create softlink to pedalboards directory
ln -s $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards /root/.pedalboards

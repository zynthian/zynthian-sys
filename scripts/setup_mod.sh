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

#Install MOD-HOST
sh $ZYNTHIAN_RECIPE_DIR/install_mod-host.sh

#Install MOD-UI
sh $ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
sh $ZYNTHIAN_RECIPE_DIR/install_phantomjs.sh

#Install MOD-SDK
sh $ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh

#Create softlink to pedalboards directory
ln -s $ZYNTHIAN_DIR/zynthian-my-data/mod-pedalboards /root/.pedalboards

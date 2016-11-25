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

#Holger scripts ...
git clone https://github.com/dcoredump/zynthian-recipe.git $ZYNTHIAN_RECIPE_DIR

#Install dependecies
sh $ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh # throws an error at the end - ignore it!

#Install MOD-HOST
sh $ZYNTHIAN_RECIPE_DIR/install_mod-host.sh
cp -af $ZYNTHIAN_SYS_DIR/etc/systemd/mod-host.service /etc/systemd/system
sed -i -- 's/BindsTo=jack2.service/#BindsTo=jack2.service/' /etc/systemd/system/mod-host.service
sed -i -- 's/After=jack2.service/#After=jack2.service/' /etc/systemd/system/mod-host.service

#Install MOD-UI
sh $ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
sh $ZYNTHIAN_RECIPE_DIR/install_phantomjs.sh
cp -af $ZYNTHIAN_SYS_DIR/etc/systemd/mod-ui.service /etc/systemd/system

#Install MOD-SDK
sh $ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh
cp -af $ZYNTHIAN_SYS_DIR/etc/systemd/mod-sdk.service /etc/systemd/system

#Create softlink to pedalboards directory
ln -s $ZYNTHIAN_DIR/zynthian-my-data/mod-pedalboards /root/.pedalboards

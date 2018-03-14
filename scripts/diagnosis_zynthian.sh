#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Diagnosis Script
# 
# Generate a report that can be used for finding & solving problems.
# 
# Copyright (C) 2015-2017 Fernando Moyano <jofemodo@zynthian.org>
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

echo "\n\n"
echo "*************************************************************************"
echo "BOOT =>"
echo "*************************************************************************"
cat /boot/config.txt
cat /boot/
ls -l /boot/overlays

echo "\n\n"
echo "*************************************************************************"
echo "ENVIRONMENT =>"
echo "*************************************************************************"
env

echo "\n\n"
echo "*************************************************************************"
echo "MODULES =>"
echo "*************************************************************************"
lsmod

echo "\n\n"
echo "*************************************************************************"
echo "CONFIG FILES"
echo "*************************************************************************"
echo "zynthian_envars.sh =>"
echo $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
echo "zynthian_custom_config.sh =>"
echo $ZYNTHIAN_CONFIG_DIR/zynthian_custom_config.sh

for each repo:
	echo "*************************************************************************"
	echo "REPOSITORY: $repo"
	echo "*************************************************************************"
	git branch
	git rev-parse HEAD
	git status

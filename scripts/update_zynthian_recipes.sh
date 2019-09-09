#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Run Update Recipes
# 
# Run the scripts contained in recipes.update directory
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

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

RECIPES_UPDATE_DIR="$ZYNTHIAN_SYS_DIR/scripts/recipes.update"

# Get System Codebase
codebase=`lsb_release -cs`

#Custom update recipes, depending on the codebase version
echo "Executing custom update recipes ..."
for r in $RECIPES_UPDATE_DIR.${codebase}/*.sh; do
	echo "Executing $r ..."
	bash $r
done

#Generic update recipes
echo "Executing update recipes ..."
for r in $RECIPES_UPDATE_DIR/*.sh; do
	echo "Executing $r ..."
	bash $r
done

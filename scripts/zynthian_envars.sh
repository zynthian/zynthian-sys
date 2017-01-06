#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Environment Vars
# 
# Setup Zynthian Environment Variables
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
# ****************************************************************************

# Git branch
export ZYNTHIAN_BRANCH="mod"

# Directory Paths
export ZYNTHIAN_DIR="/zynthian"
export ZYNTHIAN_SW_DIR="$ZYNTHIAN_DIR/zynthian-sw"
export ZYNTHIAN_UI_DIR="$ZYNTHIAN_DIR/zynthian-ui"
export ZYNTHIAN_SYS_DIR="$ZYNTHIAN_DIR/zynthian-sys"
export ZYNTHIAN_DATA_DIR="$ZYNTHIAN_DIR/zynthian-data"
export ZYNTHIAN_MY_DATA_DIR="$ZYNTHIAN_DIR/zynthian-my-data"
export ZYNTHIAN_RECIPE_DIR="$ZYNTHIAN_SYS_DIR/scripts/recipes"
export ZYNTHIAN_PLUGINS_DIR="$ZYNTHIAN_DIR/zynthian-plugins"
export ZYNTHIAN_MY_PLUGINS_DIR="$ZYNTHIAN_DIR/zynthian-my-plugins"
export ZYNTHIAN_PLUGINS_SRC_DIR="$ZYNTHIAN_SW_DIR/plugins"
export LV2_PATH="${ZYNTHIAN_PLUGINS_DIR}/lv2:${ZYNTHIAN_MY_PLUGINS_DIR}/lv2"

# Hardware Architecture & Optimization Options
machine=`uname -m 2>/dev/null`
if [ ${machine} = "armv7l" ]; then
	model=`cat /sys/firmware/devicetree/base/model 2>/dev/null`
	if [[ ${model} =~ [3] ]]; then
		CPU="-mcpu=cortex-a53"
		FPU="-mfpu=neon-fp-armv8 -mneon-for-64bits"
	else
		CPU="-mcpu=cortex-a7 -mthumb"
		FPU="-mfpu=neon-vfpv4"
	fi
	FPU="${FPU} -mfloat-abi=hard -mvectorize-with-neon-quad"
	CFLAGS_UNSAFE="-funsafe-loop-optimizations -funsafe-math-optimizations"
fi
export MACHINE_HW_NAME=$machine
export RBPI_VERSION=$model
export CFLAGS="${CPU} ${FPU}"
export CXXFLAGS=${CFLAGS}
export CFLAGS_UNSAFE
#echo "Hardware Architecture: ${machine}"
#echo "Hardware Model: ${model}"

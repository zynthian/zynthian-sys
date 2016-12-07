#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Standalone Setup Script
# 
# Standalone setup zynthian from scratch in a completely fresh 
# minibian-jessie image. No need for nothing else.
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

apt-get -y install git
git clone https://github.com/zynthian/zynthian-sys.git
cd zynthian-sys
git checkout mod
cd scripts
./setup_system_rbpi_minibian_jessie.sh

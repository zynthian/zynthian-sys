#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Standalone Setup Script
# 
# Setup zynthian from scratch in a completely fresh minibian-jessie image.
# No need for nothing else. Only run the script twice, following the next
# instructions:
#
# 1. Run first time: ./setup_zynthian.sh
# 2. Reboot: It should reboot automaticly after step 1
# 3. Run second time: ./setup_zynthian.sh
# 4. Take a good beer, sit down and relax ... ;-)
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

if [ ! -d "zynthian-sys" ]; then
	cd
	apt-get update
	apt-get -y install apt-utils
	apt-get -y install sudo git parted screen
	git clone https://github.com/zynthian/zynthian-sys.git
	cd zynthian-sys
	git checkout mod
fi

cd
cd zynthian-sys/scripts

if [ "$1" = "wiggle" ] || [ ! -f ~/.wiggled ]; then
	echo `date` >  ~/.wiggled
	./rpi-wiggle.sh
else
	./setup_system_rbpi_minibian_jessie.sh
fi

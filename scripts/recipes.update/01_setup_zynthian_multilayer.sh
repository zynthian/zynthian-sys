#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

# Test real UI branch
cd $ZYNTHIAN_UI_DIR
ui_branch=`git branch | grep "*"`
if [ "$ui_branch" == "* mod" ]; then
	echo "Upgrading to multilayer ..."

	# Update repositories filelist cache
	apt-get update

	# Update System
	apt-get -y upgrade

	# Install WIFI support
	apt-get -y install wpasupplicant firmware-brcm80211 wireless-tools

	# Install USB automount
	apt-get -y install usbmount

	# Install Python dependecies
	apt-get -y install python-dev python-pip cython

	# Install jack_capture (jackd recorder)
	bash $ZYNTHIAN_RECIPE_DIR/install_jack_capture.sh

	# Install touchosc2midi (TouchOSC Bridge)
	bash $ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh

	# Change UI to branch multilayer
	cd $ZYNTHIAN_UI_DIR
	git checkout .
	git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	git fetch origin
	git checkout multilayer
	
	# Reboot
	touch $REBOOT_FLAGFILE

else
	echo "Already upgraded to multilayer!"
fi

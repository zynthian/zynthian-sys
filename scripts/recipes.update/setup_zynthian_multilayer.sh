#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

# Test real UI branch
cd $ZYNTHIAN_UI_DIR
ui_branch=`git branch | grep "*"`
if [ "$ui_branch" != "* mod" ]; then
	echo "Already upgraded to multilayer!"
	exit
fi

# Update repositories filelist cache
apt-get update

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

# Reboot
export ZYNTHIAN_REBOOT=1

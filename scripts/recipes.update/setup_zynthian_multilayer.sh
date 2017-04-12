#!/bin/bash

if [ $ZYNTHIAN_UI_BRANCH = "multilayer" ]; then
	echo "Already in multilayer branch!"
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

# Change zynthian-ui to multilayer branch
cd $ZYNTHIAN_UI_DIR
git checkout mod
cp -fa ./zynthian_gui_config.py /tmp
git update-index --no-assume-unchanged zynthian_gui_config.py
git checkout .
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin
git checkout multilayer
cp -fa ./zynthian_gui_config.py ./zynthian_gui_config_new.py
cp -fa /tmp/zynthian_gui_config.py .

# Update Environment Vars 
cd $ZYNTHIAN_SYS_DIR
sed -i -e "s/ZYNTHIAN_UI_BRANCH\=\"mod\"/ZYNTHIAN_UI_BRANCH\=\"multilayer\"/" scripts/zynthian_envars.sh

# Reboot
reboot

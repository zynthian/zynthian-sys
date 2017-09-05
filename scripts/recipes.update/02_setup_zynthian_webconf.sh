#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

# Test real UI branch
cd $ZYNTHIAN_UI_DIR
ui_branch=`git branch | grep "*"`
if [ "$ui_branch" == "* multilayer" ]; then
	echo "Upgrading to webconf ..."

	# Update repositories filelist cache
	apt-get update

	# Update System
	apt-get -y upgrade

	# Install extra python libraries
	apt-get -y install python3-PIL python3-pil.imagetk

	# Change SYS to branch webconf
	cd $ZYNTHIAN_SYS_DIR
	git checkout .
	git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	git fetch origin
	git checkout webconf

	# Change UI to branch webconf
	cd $ZYNTHIAN_UI_DIR
	git checkout .
	git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	git fetch origin
	git checkout webconf

	# Install & enable webconf
	cd $ZYNTHIAN_DIR
	git clone https://github.com/zynthian/zynthian-webconf.git
	systemctl enable zynthian-webconf
	systemctl start zynthian-webconf

	# Reboot
	touch $REBOOT_FLAGFILE

else
	echo "Already upgraded to webconf!"
fi

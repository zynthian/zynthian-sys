#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

if [ $ZYNTHIAN_UI_BRANCH != "multilayer" ]; then
	echo "Already upgraded to webconf!"
	exit
fi

# Update repositories filelist cache
apt-get update

# Install extra python libraries
apt-get -y install python3-PIL python3-pil.imagetk

if [ $ZYNTHIAN_SYS_BRANCH = "webconf" ]; then
	echo "zynthian-sys already in webconf branch!"
else
	# Change zynthian-sys to webconf branch
	cd $ZYNTHIAN_SYS_DIR
	cp -fa ./scripts/zynthian_envars.sh /tmp
	git checkout .
	git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	git fetch origin
	git checkout webconf
	cp -fa /tmp/zynthian_envars.sh ./scripts
fi

if [ $ZYNTHIAN_UI_BRANCH = "webconf" ]; then
	echo "zynthian-ui already in webconf branch!"
else
	# Change zynthian-ui to webconf branch
	cd $ZYNTHIAN_UI_DIR
	git checkout .
	git fetch origin
	git checkout webconf
fi

# Install & enable webconf
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/zynthian/zynthian-webconf.git
systemctl enable zynthian-webconf
systemctl start zynthian-webconf

# Reboot
export ZYNTHIAN_REBOOT=1


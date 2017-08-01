#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

# Test real UI branch
cd $ZYNTHIAN_UI_DIR
ui_branch=`git branch | grep "*"`
if [ "$ui_branch" == "* webconf" ]; then
	echo "Upgrading to master..."

	# Update repositories filelist cache
	apt-get update

	# Install xinput libraries
	apt-get -y install libxi-dev xinput

	# Upgrade setBfree to solve slow speed rotary problem
	cd $ZYNTHIAN_SW_DIR/setBfree
	git checkout .
	git pull
	sed -i -- "s/-msse -msse2 -mfpmath=sse/$CFLAGS $CFLAGS_UNSAFE/g" common.mak
	sed -i -- 's/^lv2dir = \$(PREFIX)\/lib\/lv2/lv2dir = \/zynthian\/zynthian-plugins\/lv2/' common.mak
	make clean
	make -j 3
	make install
	
	# Change SYS to master branch
	cd $ZYNTHIAN_SYS_DIR
	cp -a scripts/zynthian_envars.sh /tmp
	git checkout .
	git fetch origin
	git checkout master
	cp -a /tmp/zynthian_envars.sh ./scripts

	# Change UI to master branch
	cd $ZYNTHIAN_UI_DIR
	git checkout .
	git fetch origin
	git checkout master

	# Reboot
	touch $REBOOT_FLAGFILE

else
	echo "Already upgraded to master!"
fi


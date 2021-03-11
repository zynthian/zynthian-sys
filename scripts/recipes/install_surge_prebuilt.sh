#!/bin/bash

res=`dpkg -s surge 2>&1 | grep "Status:"`
if [ "$res" == "Status: install ok installed" ]; then
	apt-get -y remove surge
fi

#apt-get -y install libxcb-cursor-dev
apt-get -y install fonts-lato ttf-mscorefonts-installer

cd $ZYNTHIAN_PLUGINS_SRC_DIR

if [ -d "zynthian-surge.lv2" ]; then
	cd zynthian-surge.lv2
	git pull
else
	git clone https://github.com/zynthian/zynthian-surge.lv2.git
	cd zynthian-surge.lv2
fi

rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Surge.lv2
ln -s $ZYNTHIAN_PLUGINS_SRC_DIR/zynthian-surge.lv2/Surge.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

rm -rf /usr/local/share/Surge
ln -s $ZYNTHIAN_PLUGINS_SRC_DIR/zynthian-surge.lv2/data /usr/local/share/Surge

cp -a ./Surge-lv2-presets-leon/* $ZYNTHIAN_MY_DATA_DIR/presets/lv2


#!/bin/bash

# phantomjs
cd $ZYNTHIAN_SW_DIR 
git clone https://github.com/fg2it/phantomjs-on-raspberry.git
mkdir -p phantomjs-raspberrypi/bin
cp phantomjs-on-raspberry/rpi-2-3/wheezy-jessie/v2.1.1/phantomjs phantomjs-raspberrypi/bin
chmod 775 phantomjs-raspberrypi/bin/phantomjs
ln -s $ZYNTHIAN_SW_DIR/phantomjs-raspberrypi/bin/phantomjs /usr/bin/phantomjs
ln -s $ZYNTHIAN_SW_DIR/phantomjs-raspberrypi/bin/phantomjs /usr/local/bin/phantomjs
mkdir -p $ZYNTHIAN_SW_DIR/mod-ui/phantomjs-1.9.0-linux-x86_64/bin
ln -s $ZYNTHIAN_SW_DIR/phantomjs-raspberrypi/bin/phantomjs $ZYNTHIAN_SW_DIR/mod-ui/phantomjs-1.9.0-linux-x86_64/bin/phantomjs

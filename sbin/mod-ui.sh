#!/bin/sh

export MOD_SCREENSHOT_JS=$ZYNTHIAN_SW_DIR/mod-ui/screenshot.js
export MOD_PHANTOM_BINARY=/usr/bin/phantomjs
export MOD_DEVICE_WEBSERVER_PORT=8888
export MOD_DEV_ENVIRONMENT=0
export MOD_LOG=1
export MOD_APP=0
export MOD_LIVE_ISO=0
export MOD_SYSTEM_OUTPUT=1
export MOD_DATA_DIR=$ZYNTHIAN_MY_DATA_DIR/mod-data

#jack_load mod-monitor
#jack_load mod-host   

cd $ZYNTHIAN_SW_DIR/mod-ui
./server.py

#jack_unload mod-host
#jack_unload mod-monitor


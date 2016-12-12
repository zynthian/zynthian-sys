#!/bin/bash

export LV2_PATH=/zynthian/zynthian-plugins/lv2:/zynthian/zynthian-my-plugins/lv2
export MOD_SCREENSHOT_JS=/zynthian/zynthian-sw/mod-ui/screenshot.js
export MOD_PHANTOM_BINARY=/usr/bin/phantomjs
export MOD_DEVICE_WEBSERVER_PORT=8888
export MOD_DEV_ENVIRONMENT=0
export MOD_LOG=1
export MOD_APP=1
export MOD_LIVE_ISO=1
export MOD_DATA_DIR=/zynthian/zynthian-my-data/mod-data

cd /zynthian/zynthian-sw/mod-ui
./server.py



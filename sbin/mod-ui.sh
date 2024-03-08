#!/bin/bash

cd $ZYNTHIAN_SW_DIR/mod-ui
source ./modui-env/bin/activate
export MOD_LOG=0
export MOD_APP=0
export MOD_LIVE_ISO=0
export MOD_HOST_DEV=0
export MOD_DEV_ENVIRONMENT=0
export MOD_SYSTEM_OUTPUT=0
export MOD_USER_FILES_DIR=$BROWSEPY_ROOT
export MOD_DEVICE_WEBSERVER_PORT=8888
python3 ./server.py

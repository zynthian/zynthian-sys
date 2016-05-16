#!/bin/bash

export ZYNTHIAN_HOME_DIR="/home/pi/zynthian"
export ZYNTHIAN_PLUGINS_DIR="$ZYNTHIAN_HOME_DIR/zynthian-plugins.sync"

export RSYNC_OPTIONS="-r -u -l -v"

#LV2 Plugins
echo "Syncing LV2 plugins ..."
rsync $RSYNC_OPTIONS /usr/lib/lv2/* $ZYNTHIAN_PLUGINS_DIR/lv2
rsync $RSYNC_OPTIONS /usr/local/lib/lv2/* $ZYNTHIAN_PLUGINS_DIR/lv2

#DSSI Plugins
echo "Syncing DSSI plugins ..."
rsync $RSYNC_OPTIONS /usr/lib/dssi/* $ZYNTHIAN_PLUGINS_DIR/dssi
rsync $RSYNC_OPTIONS /usr/local/lib/dssi/* $ZYNTHIAN_PLUGINS_DIR/dssi

#LADSPA Plugins
echo "Syncing LADSPA plugins ..."
rsync $RSYNC_OPTIONS /usr/lib/ladspa/* $ZYNTHIAN_PLUGINS_DIR/ladspa
rsync $RSYNC_OPTIONS /usr/local/lib/ladspa/* $ZYNTHIAN_PLUGINS_DIR/ladspa

#VST Plugins
echo "Syncing VST plugins ..."
rsync $RSYNC_OPTIONS /usr/lib/vst/* $ZYNTHIAN_PLUGINS_DIR/vst
rsync $RSYNC_OPTIONS /usr/local/lib/vst/* $ZYNTHIAN_PLUGINS_DIR/vst

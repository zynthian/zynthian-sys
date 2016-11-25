#!/bin/bash

source zynthian_envars.sh

echo "Updating zynthian-data ..."
cd "$ZYNTHIAN_DATA_DIR"
git pull

echo "Updating zynthian-plugins ..."
cd "$ZYNTHIAN_PLUGINS_DIR"
git pull

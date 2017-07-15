#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"

apt-get update
apt-get -y install libxi-dev xinput

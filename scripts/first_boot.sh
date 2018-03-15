#!/bin/bash

# First, delete the first boot call
$ZYNTHIAN_SYS_DIR/scripts/del_first_boot.sh

# Regenerate Keys
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Resize partition
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

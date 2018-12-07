#!/bin/bash

# Load Config Envars
source "/zynthian/config/zynthian_envars.sh"

# Regenerate Keys
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Delete the first_boot call from /etc/rc.local
sed -i -- "s/\/zynthian\/zynthian-sys\/scripts\/first_boot\.sh//" /etc/rc.local

# Resize partition
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

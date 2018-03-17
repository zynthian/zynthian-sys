#!/bin/bash

# Load Config Envars
source "/zynthian/config/zynthian_envars.sh"

# Delete the first_boot call from /etc/rc.local
sed -i -- "s/\/zynthian\/zynthian-sys\/scripts\/first_boot\.sh//" /etc/rc.local

# Regenerate Keys
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Resize partition
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

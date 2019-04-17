#!/bin/bash

# Load Config Envars
source "/zynthian/config/zynthian_envars.sh"

# Regenerate Keys
/zynthian/zynthian-sys/sbin/regenerate_keys.sh

# Enable WIFI AccessPoint (hostapd)
systemctl unmask hostpad
systemctl enable hostpad

# Delete the first_boot call from /etc/rc.local
sed -i -- "s/\/zynthian\/zynthian-sys\/scripts\/first_boot\.sh//" /etc/rc.local

# Resize partition
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

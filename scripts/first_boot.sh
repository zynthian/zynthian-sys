#!/bin/bash

# Load Config Envars
source "/zynthian/config/zynthian_envars.sh"

# Get System Codebase
codebase=`lsb_release -cs`

# Regenerate Keys
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Mke the presets for Helm engine
$ZYNTHIAN_SYS_DIR/scripts/recipes/make_helm_presets.sh


# Enable WIFI AutoAccessPoint (hostapd)
systemctl unmask hostapd

# Run distro-specific script
if [ -f "first_boot.$codebase.sh" ]; then
	./first_boot.$codebase.sh
fi

# Disable first_boot service
systemctl disable first_boot

# Resize partition
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

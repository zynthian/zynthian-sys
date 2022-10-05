#!/bin/bash

# Load Config Envars
source "/zynthian/config/zynthian_envars.sh"

# Load action-flags shell-library
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

# Hardware Autoconfig
$ZYNTHIAN_SYS_DIR/sbin/zynthian_autoconfig.py
run_reboot_flag_action_raw

# Fix ALSA mixer settings
$ZYNTHIAN_SYS_DIR/sbin/fix_alsamixer_settings.sh

# Regenerate Keys
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Enable WIFI AutoAccessPoint (hostapd)
systemctl unmask hostapd

#Regenerate cache LV2
cd $ZYNTHIAN_CONFIG_DIR/jalv
if [[ "$(ls -1q | wc -l)" -lt 20 ]]; then
	echo "Regenerating cache LV2..."
	cd $ZYNTHIAN_UI_DIR/zyngine
	python3 ./zynthian_lv2.py
fi

# Run distro-specific script
codebase=`lsb_release -cs`
cd $ZYNTHIAN_SYS_DIR/scripts
if [ -f "first_boot.$codebase.sh" ]; then
	./first_boot.$codebase.sh
fi

# Disable first_boot service
systemctl disable first_boot

# Resize partition
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

#!/bin/bash

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------

# Hardware Autoconfig
echo "Running autoconfig..." >> /root/first_boot.log
$ZYNTHIAN_SYS_DIR/sbin/zynthian_autoconfig.py 2>&1 >> /root/first_boot.log
run_reboot_flag_action_raw

# Fix ALSA mixer settings
echo "Fixing ALSA mixer settings..." >> /root/first_boot.log
$ZYNTHIAN_SYS_DIR/sbin/fix_alsamixer_settings.sh

# Regenerate Keys
echo "Regenerating keys..." >> /root/first_boot.log
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Enable WIFI AutoAccessPoint (hostapd)
echo "Unmasking WIFI access point service..." >> /root/first_boot.log
systemctl unmask hostapd

# Regenerate cache LV2
echo "Regenerating LV2 cache..." >> /root/first_boot.log
cd $ZYNTHIAN_CONFIG_DIR/jalv
if [[ "$(ls -1q | wc -l)" -lt 20 ]]; then
	echo "Regenerating cache LV2..."
	cd $ZYNTHIAN_UI_DIR/zyngine
	python3 ./zynthian_lv2.py
fi

# Disable first_boot service
systemctl disable first_boot

# Resize partition & reboot
$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh

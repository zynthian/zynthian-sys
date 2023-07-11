#!/bin/bash

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------

# Hardware Autoconfig
echo ""
echo "Running autoconfig..." >> /root/first_boot.log
$ZYNTHIAN_SYS_DIR/sbin/zynthian_autoconfig.py 2>&1 >> /root/first_boot.log
if [ -f $REBOOT_FLAGFILE ]; then
	clean_all_flags
	# Resize partition & reboot
	echo "Resizing partition..." >> /root/first_boot.log
	$ZYNTHIAN_SYS_DIR/scripts/rpi-wiggle.sh 2>&1 >> /root/first_boot.log
fi

# Fix ALSA mixer settings
echo ""
echo "Fixing ALSA mixer settings..." >> /root/first_boot.log
$ZYNTHIAN_SYS_DIR/sbin/fix_alsamixer_settings.sh 2>&1 >> /root/first_boot.log

# Regenerate Keys
echo ""
echo "Regenerating keys..." >> /root/first_boot.log
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh 2>&1 >> /root/first_boot.log

# Enable WIFI AutoAccessPoint (hostapd)
echo ""
echo "Unmasking WIFI access point service..." >> /root/first_boot.log
systemctl unmask hostapd

# Regenerate cache LV2
cd $ZYNTHIAN_CONFIG_DIR/jalv
if [[ "$(ls -1q | wc -l)" -lt 20 ]]; then
	echo ""
	echo "Regenerating LV2 cache..." >> /root/first_boot.log
	cd $ZYNTHIAN_UI_DIR/zyngine
	python3 ./zynthian_lv2.py  2>&1 >> /root/first_boot.log
fi

# Disable first_boot service
systemctl disable first_boot

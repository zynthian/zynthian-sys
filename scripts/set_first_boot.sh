#!/bin/bash

# Stop zynthian services
echo "Stopping zynthian services ..."
systemctl stop zynthian
systemctl stop zynthian-webconf

# Clean unneeded packages & apt cache
echo "Cleaning unused packages and cache ..."
apt-get -y autoremove
apt-get clean

# Delete configured wifi networks
echo "Deleting wifi networks ..."
cp -f $ZYNTHIAN_SYS_DIR/etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant

# Delete logs
echo "Deleting system logs ..."
for f in /var/log/* /var/log/**/* ; do
	if [ -f $f ]; then
		cat /dev/null > $f
	fi
done

# Clean history
echo "Cleaning shell history ..."
cat /dev/null > ~/.bash_history && history -c && history -w

# Removing user data files
echo "Removing user data files ..."
rm -f $ZYNTHIAN_MY_DATA_DIR/snapshots/last_state.zss
rm -rf $ZYNTHIAN_MY_DATA_DIR/preset_favorites/*

# Restore factory config
echo "Restoring factory config ..."
cp -a $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh $ZYNTHIAN_CONFIG_DIR
source $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
update_zynthian_sys.sh
rm -rf $ZYNTHIAN_CONFIG_DIR/img
rm -rf $ZYNTHIAN_CONFIG_DIR/jalv/presets_*

# Add First Boot Script to /etc/rc.local
echo "Enabling first boot service ..."
systemctl enable first_boot

# Message
echo "The system is going to halt. Extract the SD card and dump the image."
sleep 3
sync

# Power Off
poweroff   

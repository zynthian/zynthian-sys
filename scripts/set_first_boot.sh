#!/bin/bash

source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

if [[ "$1" != "-f" ]]; then
	echo
	echo "*************************************************************"
	echo "************ WARNING WARNING WARNING! ***********************"
	echo "*************************************************************"
	echo "This will delete all user data and restore the factory state."
	echo "*************************************************************"
	echo
	read -p "Are you sure to reset the zynthian device?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Nn]$ ]]; then
		echo "Factory reset cancelled!"
		exit 0
	fi
fi

echo "STARTING FACTORY RESET ..."
echo

# Stop zynthian services
if [[ "$VIRTUALIZATION" == "none" ]]; then
	echo "Stopping zynthian services..."
	systemctl stop zynthian
	systemctl stop zynthian-webconf
fi

# Clean unneeded packages & apt cache
echo "Cleaning unused packages and cache..."
apt -y autoremove
apt clean

# Delete configured wifi networks
clean_wifi_networks.sh

# Delete logs
echo "Deleting first boot logs..."
rm -f /root/first_boot.log
echo "Deleting system logs..."
for f in /var/log/* /var/log/**/* ; do
	if [ -f "$f" ]; then
		cat /dev/null > "$f"
	fi
done

# Removing user data files
echo "Removing user data files..."
rm -rf "$ZYNTHIAN_MY_DATA_DIR/snapshots"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/preset_favorites"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/capture"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/collections"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Audio/Tracks"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Samples/Loops"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/One-Shot"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Percussion"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Midi/patterns"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Patterns"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/IRs"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Tuning"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/Neural Models"/*
rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/IRs"/*
mkdir "$ZYNTHIAN_MY_DATA_DIR/files/IRs/deconvolved"

# Copy default snapshots
echo "Copying initial user data files..."
mkdir $ZYNTHIAN_MY_DATA_DIR/snapshots/000-Factory
cp -a $ZYNTHIAN_DATA_DIR/snapshots/* $ZYNTHIAN_MY_DATA_DIR/snapshots/000-Factory
#cp -a $ZYNTHIAN_DATA_DIR/snapshots/015-Sprammagamma.zss $ZYNTHIAN_MY_DATA_DIR/snapshots/last_state.zss

# Restore factory config
echo "Restoring factory config..."
rm -rf $ZYNTHIAN_CONFIG_DIR/img
#rm -rf $ZYNTHIAN_CONFIG_DIR/jalv/presets_*
cp -a "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh" $ZYNTHIAN_CONFIG_DIR
cp -a "$ZYNTHIAN_SYS_DIR/config/default_midi_profile.sh" "$ZYNTHIAN_CONFIG_DIR/midi-profiles/default.sh"
update_zynthian_sys.sh --first-boot
rm -rf $ZYNTHIAN_DIR/zyncoder/build
$ZYNTHIAN_DIR/zyncoder/build.sh

# Prepare plymouth animation for V5
plymouth_theme="zynloganim-inverted"
current_plymouth_theme=$(plymouth-set-default-theme) || true
if [[ -n "$current_plymouth_theme" ]]; then
	if [[ "$current_plymouth_theme" !=  "$plymouth_theme" ]]; then
		echo "Configuring plymouth theme '$plymouth_theme' ..."
		plymouth-set-default-theme -R "$plymouth_theme"
	else
		echo "Plymouth theme already configured: $plymouth_theme"
	fi
fi

# Disable zynthian UI
echo "Disabling zynthian UI service..."
systemctl disable zynthian

# Enable First Boot service
echo "Enabling first boot service..."
systemctl enable first_boot

# Clean history
echo "Cleaning shell history..."
rm -f /home/zyn/.bash_history*
rm -f /home/zyn/.history*
rm -f /root/.bash_history*
rm -f /root/.python_history
rm -f /root/.history
history -c && history -w

# Disable automatic firmware updates. It causes boot issues!!
#systemctl mask rpi-eeprom-update
# Copy firmware to boot partition so it's installed on first boot
#rpi_eeprom_reset.sh

clean_all_flags

# Message
echo "The system is going to halt. Extract the SD card and dump the image."
sleep 3
sync

# Power Off
poweroff

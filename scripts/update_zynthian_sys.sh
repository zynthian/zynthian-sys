#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian System Configuration
# 
# Configure the system for Zynthian: copy files, create directories, 
# replace values...
# 
# Copyright (C) 2015-2017 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# ****************************************************************************

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------
# Detect legacy stable prior to 2211/2210 and block branches, avoiding update.
#------------------------------------------------------------------------------

if [[ "$VIRTUALIZATION" == "none" ]] && [[ -n "$ZYNTHIAN_OS_VERSION" ]] && [[ "$ZYNTHIAN_OS_VERSION" < "2209" ]]; then
	echo "Blocking legacy stable 2109..."
	cd $ZYNTHIAN_UI_DIR
	git fetch
	git checkout .
	git checkout stable-2109
	cd $ZYNTHIAN_DIR/zyncoder
	git fetch
	git checkout .
	git checkout stable-2109
	cd $ZYNTHIAN_DIR/zynthian-webconf
	git fetch
	git checkout .
	git checkout stable-2109
	cd $ZYNTHIAN_DATA_DIR
	git fetch
	git checkout .
	git checkout stable-2109
	cd $ZYNTHIAN_SYS_DIR
	git fetch
	git checkout .
	git checkout stable-2109
	update_zynthian_sys.sh
	exit
fi

#------------------------------------------------------------------------------

echo "Updating System configuration..."

#------------------------------------------------------------------------------
# Define some functions
#------------------------------------------------------------------------------

function custom_config {
	echo "Custom Config $1..."
	cd "$1"
	if [ -d "etc" ]; then
		for file in etc/* ; do
			if [ "$file" = "etc/modules" ]; then
				cat "$file" >> /etc/modules
			else
				cp -a "$file" /etc
			fi
		done
	fi
	if [ -d "boot" ]; then
		for file in boot/* ; do
			cp -a "$file" /boot
		done
	fi
	if [ -d "config" ]; then
		for file in config/* ; do
			cp -a "$file" $ZYNTHIAN_CONFIG_DIR
		done
	fi
	if [ -d "firmware" ]; then
		for file in firmware/* ; do
			cp -a "$file" /lib/firmware
		done
	fi
}


function display_custom_config {
	custom_config "$1"

	calibration_fpath="$ZYNTHIAN_CONFIG_DIR/touchscreen/$DISPLAY_NAME"

	if [ ! -d $ZYNTHIAN_CONFIG_DIR/touchscreen ]; then
		mkdir $ZYNTHIAN_CONFIG_DIR/touchscreen
	fi

	if [ -f "calibration.conf" ]; then
		if [ ! -f "$calibration_fpath" ]; then
			cp -a calibration.conf "$calibration_fpath"
		fi
	fi

	if [ -f "$calibration_fpath" ]; then
		cp -a "$calibration_fpath" /etc/X11/xorg.conf.d/99-calibration.conf
	fi
}


#------------------------------------------------------------------------------
# Default Values for some Config Variables
#------------------------------------------------------------------------------

if [ -z "$FRAMEBUFFER" ]; then
	export FRAMEBUFFER="/dev/fb1"
fi

if [ -f "/usr/local/bin/jackd" ]; then
	export JACKD_BIN_PATH="/usr/local/bin"
else
	export JACKD_BIN_PATH="/usr/bin"
fi

if [ -z "$JACKD_OPTIONS" ]; then
	export JACKD_OPTIONS="-P 70 -t 2000 -s -d alsa -d hw:0 -r 44100 -p 256 -n 2 -X raw"
fi

if [ -z "$ZYNTHIAN_AUBIONOTES_OPTIONS" ]; then
	export ZYNTHIAN_AUBIONOTES_OPTIONS="-O complex -t 0.5 -s -88  -p yinfft -l 0.5"
fi

if [ -z "$ZYNTHIAN_HOSTSPOT_NAME" ]; then
	export ZYNTHIAN_HOSTSPOT_NAME="zynthian"
fi
if [ -z "$ZYNTHIAN_HOSTSPOT_PASSWORD" ]; then
	export ZYNTHIAN_HOSTSPOT_PASSWORD="raspberry"
fi
if [ -z "$ZYNTHIAN_HOSTSPOT_CHANNEL" ]; then
	export ZYNTHIAN_HOSTSPOT_CHANNEL="0"
fi

if [ -z "$BROWSEPY_ROOT" ]; then
	export BROWSEPY_ROOT="$ZYNTHIAN_MY_DATA_DIR/files/mod-ui"
fi

# ************** THIS WILL BE REMOVED IN NEXT REVISIONS *****************************
# EPDF hat detection/config should be integrated into "sbin/zynthian_autoconfig.py"
/zynthian/zynthian-sys/sbin/epdf_detect.sh
ZYNTHIAN_EPDF_HAT=$?
# ***********************************************************************************

#------------------------------------------------------------------------------
# Escape Config Variables to replace
#------------------------------------------------------------------------------

FRAMEBUFFER_ESC=${FRAMEBUFFER//\//\\\/}
LV2_PATH_ESC=${LV2_PATH//\//\\\/}
ZYNTHIAN_DIR_ESC=${ZYNTHIAN_DIR//\//\\\/}
ZYNTHIAN_CONFIG_DIR_ESC=${ZYNTHIAN_CONFIG_DIR//\//\\\/}
ZYNTHIAN_SYS_DIR_ESC=${ZYNTHIAN_SYS_DIR//\//\\\/}
ZYNTHIAN_UI_DIR_ESC=${ZYNTHIAN_UI_DIR//\//\\\/}
ZYNTHIAN_SW_DIR_ESC=${ZYNTHIAN_SW_DIR//\//\\\/}
BROWSEPY_ROOT_ESC=${BROWSEPY_ROOT//\//\\\/}

JACKD_BIN_PATH_ESC=${JACKD_BIN_PATH//\//\\\/}
JACKD_OPTIONS_ESC=${JACKD_OPTIONS//\//\\\/}
ZYNTHIAN_AUBIONOTES_OPTIONS_ESC=${ZYNTHIAN_AUBIONOTES_OPTIONS//\//\\\/}
ZYNTHIAN_CUSTOM_BOOT_CMDLINE=${ZYNTHIAN_CUSTOM_BOOT_CMDLINE//\n//}

if [[ "$VIRTUALIZATION" == "none" ]]; then
	RBPI_AUDIO_DEVICE=`$ZYNTHIAN_SYS_DIR/sbin/get_rbpi_audio_device.sh`
else
	RBPI_AUDIO_DEVICE="Headphones"
fi

#------------------------------------------------------------------------------
# Boot Config 
#------------------------------------------------------------------------------

BOOT_CONFIG_FPATH="/boot/firmware/config.txt"
CMDLINE_CONFIG_FPATH="/boot/firmware/cmdline.txt"

# Detect NO_ZYNTHIAN_UPDATE flag in the config.txt
if [ -f "$BOOT_CONFIG_FPATH" ] && [ -z "$NO_ZYNTHIAN_UPDATE" ]; then
	NO_ZYNTHIAN_UPDATE=`grep -e ^#NO_ZYNTHIAN_UPDATE $BOOT_CONFIG_FPATH`
fi

if [ -z "$NO_ZYNTHIAN_UPDATE" ]; then
	# Generate cmdline.txt
  cmdline="root=/dev/mmcblk0p2 rootfstype=ext4 fsck.repair=yes rootwait"

	if [ "$ZYNTHIAN_LIMIT_USB_SPEED" == "1" ]; then
		echo "USB SPEED LIMIT ENABLED"
		cmdline="$cmdline dwc_otg.speed=1"
	fi

	if [[ "$DISPLAY_KERNEL_OPTIONS" != "" ]]; then
		cmdline="$cmdline $DISPLAY_KERNEL_OPTIONS"
	fi

	if [[ "$ZYNTHIAN_CUSTOM_BOOT_CMDLINE" != "" ]]; then
    echo "CUSTOM BOOT CMDLINE => $ZYNTHIAN_CUSTOM_BOOT_CMDLINE"
	  cmdline="$cmdline $ZYNTHIAN_CUSTOM_BOOT_CMDLINE"
	fi

	if [[ "$FRAMEBUFFER" == "/dev/fb0" ]]; then
		echo "BOOT LOG DISABLED"
		cmdline="$cmdline console=tty3 logo.nologo quiet splash vt.global_cursor_default=0"
	else
		cmdline="$cmdline console=tty1 logo.nologo"
	fi

  # Customize config.txt
	cp -a $ZYNTHIAN_SYS_DIR/boot/config.txt "$BOOT_CONFIG_FPATH"

	echo "OVERCLOCKING => $ZYNTHIAN_OVERCLOCKING"
	if [[ "$ZYNTHIAN_OVERCLOCKING" == "Maximum" ]]; then
		sed -i -e "s/#OVERCLOCKING_RBPI4#/over_voltage=6\narm_freq=2000/g" "$BOOT_CONFIG_FPATH"
	elif [[ "$ZYNTHIAN_OVERCLOCKING" == "Medium" ]]; then
		sed -i -e "s/#OVERCLOCKING_RBPI4#/over_voltage=2\narm_freq=1750/g" "$BOOT_CONFIG_FPATH"
	else
		sed -i -e "s/#OVERCLOCKING_RBPI4#//g" "$BOOT_CONFIG_FPATH"
	fi

	if [[ "$ZYNTHIAN_DISABLE_RBPI_AUDIO" != "1" ]]; then
		echo "RBPI AUDIO ENABLED"
		sed -i -e "s/#RBPI_AUDIO_CONFIG#/dtparam=audio=on\naudio_pwm_mode=2/g" "$BOOT_CONFIG_FPATH"
	fi

	if [[ "$ZYNTHIAN_DISABLE_OTG" != "1" ]]; then
		echo "OTG ENABLED"
		cmdline="$cmdline modules-load=dwc2,libcomposite"
		sed -i -e "s/#OTG_CONFIG#/dtoverlay=dwc2/g" "$BOOT_CONFIG_FPATH"
	fi

	echo "SOUNDCARD CONFIG => $SOUNDCARD_CONFIG"
	sed -i -e "s/#SOUNDCARD_CONFIG#/$SOUNDCARD_CONFIG/g" "$BOOT_CONFIG_FPATH"

	# Patch piscreen config
	if [[ ( $DISPLAY_CONFIG == *"piscreen2r-notouch"* ) && ( $DISPLAY_CONFIG != *"piscreen2r-backlight"* ) ]]; then
		DISPLAY_CONFIG=$DISPLAY_CONFIG"\ndtoverlay=piscreen2r-backlight"
	fi
	echo "DISPLAY CONFIG => $DISPLAY_CONFIG"
	sed -i -e "s/#DISPLAY_CONFIG#/$DISPLAY_CONFIG/g" "$BOOT_CONFIG_FPATH"

	# Configure the act-led dtoverlay if an EPDF hat has been detected => Added to custom config!
	if [ $ZYNTHIAN_EPDF_HAT -eq 0 ]; then
		export ZYNTHIAN_CUSTOM_CONFIG="dtoverlay=act-led,activelow=off,gpio=4\n"$ZYNTHIAN_CUSTOM_CONFIG
	fi

	# Configure RTC for V5 & Z2 main boards
	# TODO => see /zynthian-sys/sbin/configure_rtc.sh!!!
	if [[ ( $ZYNTHIAN_KIT_VERSION == "V5"* ) || ( $ZYNTHIAN_KIT_VERSION == "Z2"* ) ]]; then
		export ZYNTHIAN_CUSTOM_CONFIG="dtoverlay=i2c-rtc,rv3028\n"$ZYNTHIAN_CUSTOM_CONFIG
	fi

	echo "CUSTOM CONFIG => $ZYNTHIAN_CUSTOM_CONFIG"
	sed -i -e "s/#CUSTOM_CONFIG#/$ZYNTHIAN_CUSTOM_CONFIG/g" "$BOOT_CONFIG_FPATH"

	echo "$cmdline" > "$CMDLINE_CONFIG_FPATH"
fi

# Copy extra overlays
if [ -d "$ZYNTHIAN_SYS_DIR/boot/overlays" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/boot/overlays/* /boot/overlays
fi

#------------------------------------------------------------------------------
# Zynthian Config 
#------------------------------------------------------------------------------

# Copy default envars file if needed...
if [ ! -f "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh $ZYNTHIAN_CONFIG_DIR
# Or fix it ...
else
	# Remove last part that it's been moved to zynthian_vars_extended.sh
	sed -i -e "/^\# Hardware Architecture & Optimization Options/, /ZYNTHIAN_SETUP_APT_CLEAN/d" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh

	# Fix some paths in config file
	sed -i -e "s/zynthian-data\/midi-profiles/config\/midi-profiles/g" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
	sed -i -e "s/zynthian-my-data\/midi-profiles/config\/midi-profiles/g" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
	sed -i -e "s/media\/usb0/media\/root/g" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
fi

# Generate a good LV2 path
if [ ${MACHINE_HW_NAME} = "armv7l" ]; then
	arch_libdir="arm-linux-gnueabih"
elif [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	arch_libdir="aarch64-linux-gnu"
fi
LV2_PATH="/usr/lib/lv2:/usr/lib/$arch_libdir/lv2:/usr/local/lib/lv2:/usr/local/lib/$arch_libdir/lv2:$ZYNTHIAN_PLUGINS_DIR/lv2:$ZYNTHIAN_DATA_DIR/presets/lv2:$ZYNTHIAN_MY_DATA_DIR/presets/lv2"
LV2_PATH_ESC=${LV2_PATH//\//\\\/}
sed -i -e "s/^export LV2_PATH\=.*$/export LV2_PATH=\"$LV2_PATH_ESC\"/" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh

# Zynthian apt repository
#if [ "$ZYNTHIAN_SYS_BRANCH" != "stable" ]; then
#	sed -i -e "s/zynthian-stable/zynthian-testing/g" /etc/apt/sources.list.d/zynthian.list
#fi

# Install zynthian repository public key
#if [ ! -f "/etc/apt/sources.list.d/zynthian.list" ]; then
#	apt-key add $ZYNTHIAN_SYS_DIR/etc/apt/pubkeys/zynthian.pub
#fi

# Copy zynthian specific config files
cp -a $ZYNTHIAN_SYS_DIR/config/wiring-profiles $ZYNTHIAN_CONFIG_DIR
if [ ! -f "$ZYNTHIAN_CONFIG_DIR/config_backup_items.txt" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/config/config_backup_items.txt $ZYNTHIAN_CONFIG_DIR
fi
if [ ! -f "$ZYNTHIAN_CONFIG_DIR/data_backup_items.txt" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/config/data_backup_items.txt $ZYNTHIAN_CONFIG_DIR
fi
cp -a $ZYNTHIAN_SYS_DIR/config/sidechain.json $ZYNTHIAN_CONFIG_DIR

# Delete deprecated config files
if [ -f "$ZYNTHIAN_CONFIG_DIR/backup_items.txt" ]; then
	rm -f $ZYNTHIAN_CONFIG_DIR/backup_items.txt
fi
if [ -f "$ZYNTHIAN_CONFIG_DIR/zynthian_custom_config.sh" ]; then
	rm -f $ZYNTHIAN_CONFIG_DIR/zynthian_custom_config.sh
fi

# Fix/Setup MIDI-profiles data directory
cd $ZYNTHIAN_CONFIG_DIR
if [ -d "$ZYNTHIAN_MY_DATA_DIR/midi-profiles" ]; then
	mv "$ZYNTHIAN_MY_DATA_DIR/midi-profiles" .
fi
if [ ! -d "midi-profiles" ]; then
	mkdir "midi-profiles"
	cp "$ZYNTHIAN_SYS_DIR/config/default_midi_profile.sh" "midi-profiles/default.sh"
fi

# Fix/Setup Default Jalv LV2-plugin list
cd $ZYNTHIAN_CONFIG_DIR
if [ ! -d "jalv" ]; then
	mkdir "jalv"
fi
if [ -f "jalv_plugins.json" ]; then
	mv "jalv_plugins.json" "jalv/plugins.json"
	mv "all_jalv_plugins.json" "jalv/all_plugins.json"
fi
if [ ! -f "jalv/plugins.json" ]; then
	cp "$ZYNTHIAN_SYS_DIR/config/default_jalv_plugins.json" "jalv/plugins.json"
fi

export ZYNTHIAN_PIANOTEQ_DIR="$ZYNTHIAN_SW_DIR/pianoteq6"
# Setup Pianoteq binary
if [ ! -L "$ZYNTHIAN_PIANOTEQ_DIR/pianoteq" ]; then
	ln -s "$ZYNTHIAN_PIANOTEQ_DIR/Pianoteq 6 STAGE" "$ZYNTHIAN_PIANOTEQ_DIR/pianoteq"
fi
# Generate LV2 presets
if [[ "$VIRTUALIZATION" == "none" ]]; then
	ptq_version=$($ZYNTHIAN_PIANOTEQ_DIR/pianoteq --version | cut -d' ' -f4)
	if [[ "$version" > "7.2.0" ]]; then
		n_presets=$(find "$ZYNTHIAN_MY_DATA_DIR/presets/lv2" -name "Pianoteq 7 *-factory-presets*.lv2" -printf '.' | wc -m)
		if [[ "$n_presets" == 0 ]]; then
			$ZYNTHIAN_PIANOTEQ_DIR/pianoteq --export-lv2-presets $ZYNTHIAN_MY_DATA_DIR/presets/lv2
		fi
	fi
fi
# Setup Pianoteq User Presets Directory
if [ ! -d "/root/.local/share/Modartt/Pianoteq/Presets/My Presets" ]; then
	mkdir -p "/root/.local/share/Modartt/Pianoteq/Presets/My Presets"
fi
if [ ! -L "$ZYNTHIAN_MY_DATA_DIR/presets/pianoteq" ]; then
	ln -s "/root/.local/share/Modartt/Pianoteq/Presets/My Presets" "$ZYNTHIAN_MY_DATA_DIR/presets/pianoteq"
fi
# Setup Pianoteq Config files
if [ ! -d "/root/.config/Modartt" ]; then
	mkdir -p "/root/.config/Modartt"
	cp $ZYNTHIAN_DATA_DIR/pianoteq6/*.prefs /root/.config/Modartt
fi
# Setup Pianoteq MidiMappings
if [ ! -d "/root/.config/Modartt/Pianoteq/MidiMappings" ]; then
	mkdir -p "/root/.local/share/Modartt/Pianoteq/MidiMappings"
	cp $ZYNTHIAN_DATA_DIR/pianoteq6/Zynthian.ptm /root/.local/share/Modartt/Pianoteq/MidiMappings
fi
# Fix Pianoteq Presets Cache location
if [ -d "$ZYNTHIAN_MY_DATA_DIR/pianoteq6" ]; then
	mv "$ZYNTHIAN_MY_DATA_DIR/pianoteq6" $ZYNTHIAN_CONFIG_DIR
fi
# Setup browsepy directories
if [ ! -d "$BROWSEPY_ROOT" ]; then
     mkdir -p $BROWSEPY_ROOT
fi
# TODO create other directories and symlinks to existing file types in $ZYNTHIAN_MY_DATA_DIR
if [ ! -d "$BROWSEPY_ROOT/Speaker Cabinets IRs" ]; then
     mkdir -p "$BROWSEPY_ROOT/Speaker Cabinets IRs"
fi

# Fix Aeolus config file: Remove unsupported "-J" option.
sed -i -e "s/ \-J / /g" /etc/aeolus.conf

#--------------------------------------
# System Config
#--------------------------------------

if [ -z "$NO_ZYNTHIAN_UPDATE" ]; then
	# Copy "etc" config files
	#cp -a $ZYNTHIAN_SYS_DIR/etc/apt/sources.list.d/* /etc/apt/sources.list.d
	cp -a $ZYNTHIAN_SYS_DIR/etc/modules /etc
	cp -a $ZYNTHIAN_SYS_DIR/etc/inittab /etc
	cp -an $ZYNTHIAN_SYS_DIR/etc/dbus-1/* /etc/dbus-1
	cp -an $ZYNTHIAN_SYS_DIR/etc/security/* /etc/security
	cp -a $ZYNTHIAN_SYS_DIR/etc/systemd/* /etc/systemd/system
	cp -a $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d 2>/dev/null
	cp -a $ZYNTHIAN_SYS_DIR/etc/avahi/* /etc/avahi
	cp -a $ZYNTHIAN_SYS_DIR/etc/default/* /etc/default
	cp -a $ZYNTHIAN_SYS_DIR/etc/ld.so.conf.d/* /etc/ld.so.conf.d
	cp -a $ZYNTHIAN_SYS_DIR/etc/modprobe.d/* /etc/modprobe.d
	cp -an $ZYNTHIAN_SYS_DIR/etc/vim/* /etc/vim
	cp -a $ZYNTHIAN_SYS_DIR/etc/update-motd.d/* /etc/update-motd.d
	# WIFI Hotspot
	cp -an $ZYNTHIAN_SYS_DIR/etc/hostapd/* /etc/hostapd
	cp -a $ZYNTHIAN_SYS_DIR/etc/dnsmasq.conf /etc
fi

# Display zynthian info on ssh login
#sed -i -e "s/PrintMotd no/PrintMotd yes/g" /etc/ssh/sshd_config

# Fix devmon config (USB-disk automounter)
#/etc/conf.d/devmon =>
#ARGS="--exec-on-drive \"/usr/local/bin/send_osc 1370 /CUIA/DRIVE_MOUNT %f\" --exec-on-remove \"/usr/local/bin/send_osc 1370 /CUIA/DRIVE_REMOVE %f\""

# X11 Display config
if [ ! -d "/etc/X11/xorg.conf.d" ]; then
	mkdir /etc/X11/xorg.conf.d
fi
#cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-fbdev.conf /etc/X11/xorg.conf.d
#sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/X11/xorg.conf.d/99-fbdev.conf
if [ -f "/etc/X11/xorg.conf.d/99-fbdev.conf" ]; then
	rm -f "/etc/X11/xorg.conf.d/99-fbdev.conf"
fi

if [ "$ZYNTHIAN_UI_ENABLE_CURSOR" == "1" ]; then
	X11_SERVER_OPTIONS=""
else
	X11_SERVER_OPTIONS="-nocursor"
fi

# Copy fonts to system directory
rsync -r --del $ZYNTHIAN_UI_DIR/fonts/* /usr/share/fonts/truetype

# Fix problem with WLAN interfaces numbering
if [ -f "/etc/udev/rules.d/70-persistent-net.rules" ]; then
	mv /etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules.inactive
	mv /lib/udev/rules.d/75-persistent-net-generator.rules /lib/udev/rules.d/75-persistent-net-generator.rules.inactive
fi
#if [ -f "/etc/udev/rules.d/70-persistent-net.rules.inactive" ]; then
#	rm -f /etc/udev/rules.d/70-persistent-net.rules.inactive
#fi
# Fix timeout in network initialization
if [ ! -d "/etc/systemd/system/networking.service.d/reduce-timeout.conf" ]; then
	mkdir -p "/etc/systemd/system/networking.service.d"
	echo -e "[Service]\nTimeoutStartSec=1\n" > "/etc/systemd/system/networking.service.d/reduce-timeout.conf"
fi

# WIFI Hotspot extra config
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
echo "" > /etc/network/interfaces

# User Config (root)
# => bash
sed -i -e "s/config\/zynthian_envars.sh/zynthian-sys\/scripts\/zynthian_envars_extended.sh \> \/dev\/null 2\>\&1/g" /root/.bashrc

# => ZynAddSubFX Config
if [ -f $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg ]; then
	cp -a $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg
fi
# => vim config
if [ -f /etc/vim/vimrc.local ]; then
	cp -a /etc/vim/vimrc.local /root/.vimrc
fi

# => vncserver password
if [ ! -d "/root/.vnc" ]; then
	mkdir "/root/.vnc"
fi
if [ ! -f "/root/.vnc/passwd" ]; then
	echo "raspberry" | vncpasswd -f > /root/.vnc/passwd
	chmod go-r /root/.vnc/passwd
fi
# => novnc launcher
if [ ! -f "$ZYNTHIAN_SW_DIR/noVNC/utils/novnc_proxy" ]; then
	ln -s "$ZYNTHIAN_SW_DIR/noVNC/utils/launch.sh" "$ZYNTHIAN_SW_DIR/noVNC/utils/novnc_proxy"
fi

# => Xsession config
cp -an $ZYNTHIAN_SYS_DIR/etc/xsessionrc /root/.xsessionrc

# => Xfce4 config
rsync -r --del $ZYNTHIAN_SYS_DIR/etc/xfce4.config/ /root/.config/xfce4/

# Device Custom files
display_config_custom_dir="$ZYNTHIAN_SYS_DIR/custom/display/$DISPLAY_NAME"
if [ -d "$display_config_custom_dir" ]; then
	display_custom_config "$display_config_custom_dir"
fi

soundcard_config_custom_dir="$ZYNTHIAN_SYS_DIR/custom/soundcard/$SOUNDCARD_NAME"
if [ -d "$soundcard_config_custom_dir" ]; then
	custom_config "$soundcard_config_custom_dir"
fi

if [ "$VIRTUALIZATION" == "none" ]; then
	# Fix ALSA Mixer settings
	$ZYNTHIAN_SYS_DIR/sbin/fix_alsamixer_settings.sh
	# Fix Soundcard Mixer Control List
	$ZYNTHIAN_SYS_DIR/sbin/fix_soundcard_mixer_ctrls.py
fi

# Fix jackd parameters
i=`echo $JACKD_OPTIONS | sed 's/\( *-X raw\)//'`
if [ "$i" != "$JACKD_OPTIONS" ]; then
  echo "Fixing jackd parameters ..."
  echo "export JACKD_OPTIONS=\"$i\"" >> /tmp/update_envars.sh
  update_envars.py /tmp/update_envars.sh no_update_sys
fi

# Replace config vars in hostapd.conf
sed -i -e "s/#ZYNTHIAN_HOTSPOT_NAME#/$ZYNTHIAN_HOSTSPOT_NAME/g" /etc/hostapd/hostapd.conf
sed -i -e "s/#ZYNTHIAN_HOTSPOT_PASSWORD#/$ZYNTHIAN_HOSTSPOT_PASSWORD/g" /etc/hostapd/hostapd.conf
sed -i -e "s/#ZYNTHIAN_HOTSPOT_CHANNEL#/$ZYNTHIAN_HOSTSPOT_CHANNEL/g" /etc/hostapd/hostapd.conf

# Replace config vars in Systemd service files
# First Boot service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/first_boot.service
# Cpu-performance service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/cpu-performance.service
# Jackd service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/jack2.service
sed -i -e "s/#JACKD_OPTIONS#/$JACKD_OPTIONS_ESC/g" /etc/systemd/system/jack2.service
sed -i -e "s/#LV2_PATH#/$LV2_PATH_ESC/g" /etc/systemd/system/jack2.service
# USB-gadget service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/usb-gadget.service
# a2jmidid service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/a2jmidid.service
# mod-ttymidi service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/mod-ttymidi.service
# Aubionotes service
sed -i -e "s/#ZYNTHIAN_AUBIONOTES_OPTIONS#/$ZYNTHIAN_AUBIONOTES_OPTIONS_ESC/g" /etc/systemd/system/aubionotes.service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/aubionotes.service
# jackrtpmidid service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/jackrtpmidid.service
# jacknetumpd service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/jacknetumpd.service
# qmidinet service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/qmidinet.service
# touchosc2midi service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/touchosc2midi.service
# jack-midi-clock service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/jack-midi-clock.service
# headphones service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/headphones.service
sed -i -e "s/#RBPI_AUDIO_DEVICE#/$RBPI_AUDIO_DEVICE/g" /etc/systemd/system/headphones.service
# MOD-HOST service
sed -i -e "s/#LV2_PATH#/$LV2_PATH_ESC/g" /etc/systemd/system/mod-host.service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/mod-host.service
# MOD-SDK service
sed -i -e "s/#LV2_PATH#/$LV2_PATH_ESC/g" /etc/systemd/system/mod-sdk.service
sed -i -e "s/#ZYNTHIAN_SW_DIR#/$ZYNTHIAN_SW_DIR_ESC/g" /etc/systemd/system/mod-sdk.service
# MOD-UI service
sed -i -e "s/#LV2_PATH#/$LV2_PATH_ESC/g" /etc/systemd/system/mod-ui.service
sed -i -e "s/#ZYNTHIAN_SW_DIR#/$ZYNTHIAN_SW_DIR_ESC/g" /etc/systemd/system/mod-ui.service
sed -i -e "s/#BROWSEPY_ROOT#/$BROWSEPY_ROOT_ESC/g" /etc/systemd/system/mod-ui.service
# browsepy service
sed -i -e "s/#BROWSEPY_ROOT#/$BROWSEPY_ROOT_ESC/g" /etc/systemd/system/browsepy.service
# VNCServcer service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/vncserver0.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/vncserver1.service
# noVNC service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/novnc0.service
sed -i -e "s/#ZYNTHIAN_SW_DIR#/$ZYNTHIAN_SW_DIR_ESC/g" /etc/systemd/system/novnc0.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/novnc1.service
sed -i -e "s/#ZYNTHIAN_SW_DIR#/$ZYNTHIAN_SW_DIR_ESC/g" /etc/systemd/system/novnc1.service
# Zynthian Service
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_UI_DIR#/$ZYNTHIAN_UI_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#X11_SERVER_OPTIONS#/$X11_SERVER_OPTIONS/g" /etc/systemd/system/zynthian.service

# Zynthian Debug Service
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_UI_DIR#/$ZYNTHIAN_UI_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#X11_SERVER_OPTIONS#/$X11_SERVER_OPTIONS/g" /etc/systemd/system/zynthian_debug.service
# Zynthian Webconf Service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian-webconf.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian-webconf.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian-webconf.service
# Zynthian Config-On-Boot Service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian-config-on-boot.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian-config-on-boot.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian-config-on-boot.service
# Zynthian PWM Fan Service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian-pwm-fan.service
sed -i -e "s/#ZYNTHIAN_UI_DIR#/$ZYNTHIAN_UI_DIR_ESC/g" /etc/systemd/system/zynthian-pwm-fan.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian-pwm-fan.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian-pwm-fan.service

# Reload Systemd scripts
systemctl daemon-reload

# Enable needed services
if [ "$(systemctl is-enabled usb-gadget)" != "enabled" ]; then
	echo "Enabling USB gadget ..."
	systemctl enable usb-gadget
fi

# Enable the pwm fan service if an EPDF hat is detected
if [ $ZYNTHIAN_EPDF_HAT -eq 0 ]; then
    systemctl enable zynthian-pwm-fan
fi

if [ -f "$ZYNTHIAN_MY_DATA_DIR/scripts/update_zynthian_sys.sh" ]; then
	bash "$ZYNTHIAN_MY_DATA_DIR/scripts/update_zynthian_sys.sh"
fi

run_flag_actions

#------------------------------------------------------------------------------

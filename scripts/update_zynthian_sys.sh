#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian System Configuration
# 
# Configure the system for Zynthian: copy files, create directories, 
# replace values, ...
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
# Get System Codebase
#------------------------------------------------------------------------------

ZYNTHIAN_OS_CODEBASE=`lsb_release -cs`

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

if [ -f "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

#------------------------------------------------------------------------------

echo "Updating System configuration ..."

#------------------------------------------------------------------------------
# Reboot flag-file
#------------------------------------------------------------------------------

if [ -z "$REBOOT_FLAGFILE" ]; then
	export REBOOT_FLAGFILE="/tmp/zynthian_reboot"
	rm -f $REBOOT_FLAGFILE
fi

#------------------------------------------------------------------------------
# Define some functions
#------------------------------------------------------------------------------

function custom_config {
	echo "Custom Config $1 ..."
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

if [ -z "$ZYNTHIAN_HOSTSPOT_CHANNEL" ]; then
	export ZYNTHIAN_HOSTSPOT_CHANNEL="6"
fi

if [ -z "$ZYNTHIAN_HOSTSPOT_PASSWORD" ]; then
	export ZYNTHIAN_HOSTSPOT_PASSWORD="raspberry"
fi

#Check for EPDF Hat
/zynthian/zynthian-sys/scripts/epdf_detect.sh 
ZYNTHIAN_EPDF_HAT=$?

#Configure the ACT_LED if an EPDF hat is detected
if [ $ZYNTHIAN_EPDF_HAT -eq 0 ]; then
	export ACT_LED_CONFIG="dtoverlay=act-led,activelow=off,gpio=4\n\n"     
else
	export ACT_LED_CONFIG=""
fi

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

JACKD_BIN_PATH_ESC=${JACKD_BIN_PATH//\//\\\/}
JACKD_OPTIONS_ESC=${JACKD_OPTIONS//\//\\\/}
ZYNTHIAN_AUBIONOTES_OPTIONS_ESC=${ZYNTHIAN_AUBIONOTES_OPTIONS//\//\\\/}

if [ -f "/proc/stat" ]; then
	RBPI_AUDIO_DEVICE=`$ZYNTHIAN_SYS_DIR/sbin/get_rbpi_audio_device.sh`
else
	RBPI_AUDIO_DEVICE="Headphones"
fi

#------------------------------------------------------------------------------
# Boot Config 
#------------------------------------------------------------------------------

# Detect NO_ZYNTHIAN_UPDATE flag in the config.txt
if [ -f "/boot/config.txt" ] && [ -z "$NO_ZYNTHIAN_UPDATE" ]; then
	NO_ZYNTHIAN_UPDATE=`grep -e ^#NO_ZYNTHIAN_UPDATE /boot/config.txt`
fi

if [ -z "$NO_ZYNTHIAN_UPDATE" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/boot/cmdline.txt /boot
	cp -a $ZYNTHIAN_SYS_DIR/boot/config.txt /boot

	if [ "$ZYNTHIAN_LIMIT_USB_SPEED" == "1" ]; then
		sed -i '1s/^/dwc_otg.speed=1 /' /boot/cmdline.txt
	fi

	echo "SOUNDCARD CONFIG => $SOUNDCARD_CONFIG"
	sed -i -e "s/#SOUNDCARD_CONFIG#/$SOUNDCARD_CONFIG/g" /boot/config.txt
	
	echo "DISPLAY CONFIG => $DISPLAY_CONFIG"
	sed -i -e "s/#DISPLAY_CONFIG#/$DISPLAY_CONFIG/g" /boot/config.txt
	
	echo "ACT LED CONFIG => $ACT_LED_CONFIG"
	sed -i -e "s/#ACT_LED_CONFIG#/$ACT_LED_CONFIG/g" /boot/config.txt
fi

# Copy extra overlays
cp -a $ZYNTHIAN_SYS_DIR/boot/overlays/* /boot/overlays

#------------------------------------------------------------------------------
# Zynthian Config 
#------------------------------------------------------------------------------

# Copy default envars file if needed ...
if [ ! -f "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh $ZYNTHIAN_CONFIG_DIR
fi

# Fix some paths in config file
sed -i -e "s/zynthian-data\/midi-profiles/config\/midi-profiles/g" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh
sed -i -e "s/zynthian-my-data\/midi-profiles/config\/midi-profiles/g" $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh

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

# Setup Pianoteq binary
if [ ! -L "$ZYNTHIAN_SW_DIR/pianoteq6/pianoteq" ]; then
	ln -s "$ZYNTHIAN_SW_DIR/pianoteq6/Pianoteq 6 STAGE" "$ZYNTHIAN_SW_DIR/pianoteq6/pianoteq"
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

# Setup Aeolus Config
if [ -d "/usr/share/aeolus" ]; then
	# => Delete specific Aeolus config for replacing with the newer one
	cd $ZYNTHIAN_DATA_DIR
	res=`git rev-parse HEAD`
	if [ "$res" == "ba07bbc8c10cd582c1eea54d40f153fc0ad03dda" ]; then
		rm -f /root/.aeolus-presets
		echo "Deleting incompatible Aeolus presets file..."
	fi
	# => Copy presets file if it doesn't exist
	if [ ! -f "/root/.aeolus-presets" ]; then
		cp -a $ZYNTHIAN_DATA_DIR/aeolus/aeolus-presets /root/.aeolus-presets
	fi
	# => Copy default Waves files if needed
	if [ -n "$(ls -A /usr/share/aeolus/stops/waves 2>/dev/null)" ]; then
		echo "Aeolus Waves already exist!"
	else
		echo "Copying default Aeolus Waves ..."
		cd /usr/share/aeolus/stops
		tar xfz $ZYNTHIAN_DATA_DIR/aeolus/waves.tgz
	fi
fi

#--------------------------------------
# System Config
#--------------------------------------

if [ -z "$NO_ZYNTHIAN_UPDATE" ]; then
	# Copy "etc" config files
	cp -a $ZYNTHIAN_SYS_DIR/etc/modules /etc
	cp -a $ZYNTHIAN_SYS_DIR/etc/inittab /etc
	cp -a $ZYNTHIAN_SYS_DIR/etc/network/* /etc/network
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
	cp -a $ZYNTHIAN_SYS_DIR/etc/hostapd/* /etc/hostapd
	cp -a $ZYNTHIAN_SYS_DIR/etc/dnsmasq.conf /etc
	# WIFI Network
	#rm -f /etc/wpa_supplicant/wpa_supplicant.conf
	cp -an $ZYNTHIAN_SYS_DIR/etc/wpa_supplicant/wpa_supplicant.conf $ZYNTHIAN_CONFIG_DIR
fi

# Display zynthian info on ssh login
#sed -i -e "s/PrintMotd no/PrintMotd yes/g" /etc/ssh/sshd_config

# Fix usbmount
if [ "$ZYNTHIAN_OS_CODEBASE" == "stretch" ]; then
	if [ -f "/lib/systemd/system/systemd-udevd.service" ]; then
		sed -i -e "s/MountFlags\=slave/MountFlags\=shared/g" /lib/systemd/system/systemd-udevd.service
	fi
elif [ "$ZYNTHIAN_OS_CODEBASE" == "buster" ]; then
	if [ -f "/lib/systemd/system/systemd-udevd.service" ]; then
		sed -i -e "s/PrivateMounts\=yes/PrivateMounts\=no/g" /lib/systemd/system/systemd-udevd.service
	fi
fi

# X11 Display config
if [ ! -d "/etc/X11/xorg.conf.d" ]; then
	mkdir /etc/X11/xorg.conf.d
fi
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-fbdev.conf /etc/X11/xorg.conf.d
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/X11/xorg.conf.d/99-fbdev.conf

# Copy fonts to system directory
rsync -r -u --del $ZYNTHIAN_UI_DIR/fonts/* /usr/share/fonts/truetype

# Fix problem with WLAN interfaces numbering
if [ -f "/etc/udev/rules.d/70-persistent-net.rules" ]; then
	mv /etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules.inactive
	mv /lib/udev/rules.d/75-persistent-net-generator.rules /lib/udev/rules.d/75-persistent-net-generator.rules.inactive
fi
#if [ -f "/etc/udev/rules.d/70-persistent-net.rules.inactive" ]; then
#	rm -f /etc/udev/rules.d/70-persistent-net.rules.inactive
#fi
#Fix timeout in network initialization
if [ ! -d "/etc/systemd/system/networking.service.d/reduce-timeout.conf" ]; then
	mkdir -p "/etc/systemd/system/networking.service.d"
	echo -e "[Service]\nTimeoutStartSec=1\n" > "/etc/systemd/system/networking.service.d/reduce-timeout.conf"
fi

# WIFI Hotspot extra config
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
echo "" > /etc/network/interfaces


# User Config (root)
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
if [ ! -f "/root/.vncpasswd" ]; then
	echo "raspberry" | vncpasswd -f > /root/.vnc/passwd
	chmod go-r /root/.vnc/passwd
fi

# Zynthian Specific Config Files
if [ ! -f "$ZYNTHIAN_CONFIG_DIR/system_backup_items.txt" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/config/system_backup_items.txt $ZYNTHIAN_CONFIG_DIR
fi
if [ ! -f "$ZYNTHIAN_CONFIG_DIR/data_backup_items.txt" ]; then
	cp -a $ZYNTHIAN_SYS_DIR/config/data_backup_items.txt $ZYNTHIAN_CONFIG_DIR
fi
if [ -f "$ZYNTHIAN_CONFIG_DIR/backup_items.txt" ]; then
	rm -f $ZYNTHIAN_CONFIG_DIR/backup_items.txt
fi
rm -f $ZYNTHIAN_CONFIG_DIR/zynthian_custom_config.sh

# Device Custom files
display_config_custom_dir="$ZYNTHIAN_SYS_DIR/custom/display/$DISPLAY_NAME"
if [ -d "$display_config_custom_dir" ]; then
	display_custom_config "$display_config_custom_dir"
fi

soundcard_config_custom_dir="$ZYNTHIAN_SYS_DIR/custom/soundcard/$SOUNDCARD_NAME"
if [ -d "$soundcard_config_custom_dir" ]; then
	custom_config "$soundcard_config_custom_dir"
fi

# Fix Soundcard Mixer Control List => TO BE REMOVED IN THE FUTURE!!!
if [ -f "/proc/stat" ]; then
	$ZYNTHIAN_SYS_DIR/sbin/fix_soundcard_mixer_ctrls.py
fi

# AudioInjector Alsa Mixer Customization
if [ "$SOUNDCARD_NAME" == "AudioInjector" ]; then
	echo "Configuring Alsa Mixer for AudioInjector ..."
	amixer -c audioinjectorpi sset 'Output Mixer HiFi' unmute
	amixer -c audioinjectorpi cset numid=10,iface=MIXER,name='Line Capture Switch' 1
fi
 
if [ "$SOUNDCARD_NAME" == "AudioInjector Ultra" ]; then
	echo "Configuring Alsa Mixer for AudioInjector Ultra ..."
	amixer -c audioinjectorul cset name='DAC Switch' 0
	amixer -c audioinjectorul cset name='DAC Volume' 240
	amixer -c audioinjectorul cset name='DAC INV Switch' 0
	amixer -c audioinjectorul cset name='DAC Soft Ramp Switch' 0
	amixer -c audioinjectorul cset name='DAC Zero Cross Switch' 0
	amixer -c audioinjectorul cset name='De-emp 44.1kHz Switch' 0
	amixer -c audioinjectorul cset name='E to F Buffer Disable Switch' 0
	amixer -c audioinjectorul cset name='DAC Switch' 1
fi

# Add extra modules
if [[ $RBPI_VERSION == "Raspberry Pi 4"* ]]; then
	echo -e "dwc2\\ng_midi\\n" >> /etc/modules
fi

# Replace config vars in hostapd.conf
sed -i -e "s/#ZYNTHIAN_HOTSPOT_NAME#/$ZYNTHIAN_HOSTSPOT_NAME/g" /etc/hostapd/hostapd.conf
sed -i -e "s/#ZYNTHIAN_HOTSPOT_CHANNEL#/$ZYNTHIAN_HOSTSPOT_CHANNEL/g" /etc/hostapd/hostapd.conf
sed -i -e "s/#ZYNTHIAN_HOTSPOT_PASSWORD#/$ZYNTHIAN_HOSTSPOT_PASSWORD/g" /etc/hostapd/hostapd.conf

# Replace config vars in Systemd service files
# First Boot service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/first_boot.service
# Cpu-performance service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/cpu-performance.service
# Wifi-Setup service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/wifi-setup.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/wifi-setup.service
# Splash-Screen Service
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/splash-screen.service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/splash-screen.service
sed -i -e "s/#ZYNTHIAN_UI_DIR#/$ZYNTHIAN_UI_DIR_ESC/g" /etc/systemd/system/splash-screen.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/splash-screen.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/splash-screen.service
# Jackd service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/jack2.service
sed -i -e "s/#JACKD_OPTIONS#/$JACKD_OPTIONS_ESC/g" /etc/systemd/system/jack2.service
sed -i -e "s/#LV2_PATH#/$LV2_PATH_ESC/g" /etc/systemd/system/jack2.service
# a2jmidid service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/a2jmidid.service
# mod-ttymidi service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/mod-ttymidi.service
# Aubionotes service
sed -i -e "s/#ZYNTHIAN_AUBIONOTES_OPTIONS#/$ZYNTHIAN_AUBIONOTES_OPTIONS_ESC/g" /etc/systemd/system/aubionotes.service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/aubionotes.service
# jackrtpmidid service
sed -i -e "s/#JACKD_BIN_PATH#/$JACKD_BIN_PATH_ESC/g" /etc/systemd/system/jackrtpmidid.service
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
# Zynthian Service
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_UI_DIR#/$ZYNTHIAN_UI_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian.service
# Zynthian Debug Service
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_DIR#/$ZYNTHIAN_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_UI_DIR#/$ZYNTHIAN_UI_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_SYS_DIR#/$ZYNTHIAN_SYS_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
sed -i -e "s/#ZYNTHIAN_CONFIG_DIR#/$ZYNTHIAN_CONFIG_DIR_ESC/g" /etc/systemd/system/zynthian_debug.service
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
#
# Reconfigure System Libraries
ldconfig

# Reload Systemd scripts
systemctl daemon-reload

#enable the pwm fan service if an EPDF hat is detected, or disable it if hat not present
if [ $ZYNTHIAN_EPDF_HAT -eq 0 ]; then
    systemctl enable zynthian-pwm-fan
else
    systemctl disable zynthian-pwm-fan
fi

if [ -f "$ZYNTHIAN_MY_DATA_DIR/scripts/update_zynthian_sys.sh" ]; then
	bash "$ZYNTHIAN_MY_DATA_DIR/scripts/update_zynthian_sys.sh"
fi


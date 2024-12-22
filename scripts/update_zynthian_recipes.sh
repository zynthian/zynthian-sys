#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Run Update Recipes
# 
# Run the scripts contained in recipes.update directory
# 
# Copyright (C) 2015-2024 Fernando Moyano <jofemodo@zynthian.org>
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
# Run update recipes ...
#------------------------------------------------------------------------------

aptpkgs=""

#Custom update recipes, depending on the codebase version
echo "Executing update recipes..."
# -----------------------------------------------------------------------------
# Load current patchlevel
# -----------------------------------------------------------------------------

if [ -f "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt" ]; then
	current_patchlevel=$(cat "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt")
else
	current_patchlevel="20240220.1"
	echo "$current_patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
fi

# This should be removed in the next weeks ...
# Fix typo in patchlevel => DISASTER!!!
if [[ "$current_patchlevel" == "20240515.3" ]]; then
	current_patchlevel="20240415.3"
fi

echo "Current patch level: $current_patchlevel"

# -----------------------------------------------------------------------------
# Patches to testing image until stable ORAM release
# -----------------------------------------------------------------------------

patchlevel="20240221.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	echo "set enable-bracketed-paste off" > /root/.inputrc
	$ZYNTHIAN_RECIPE_DIR/install_dexed_lv2.sh
	$ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
fi

patchlevel="20240221.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	wget -O - https://deb.zynthian.org/deb-zynthian-org.gpg > "/etc/apt/trusted.gpg.d/deb-zynthian-org.gpg"
	echo "deb https://deb.zynthian.org/zynthian-testing bookworm main" > "/etc/apt/sources.list.d/zynthian.list"
	#echo "deb https://deb.zynthian.org/zynthian-stable bookworm main" > "/etc/apt/sources.list.d/zynthian.list"
	apt -y remove libsndfile1-dev
	aptpkgs="$aptpkgs libsdl2-dev libibus-1.0-dev gir1.2-ibus-1.0 libdecor-0-dev libflac-dev libgbm-dev \
	libibus-1.0-5 libmpg123-dev libvorbis-dev libogg-dev libopus-dev libpulse-dev libpulse-mainloop-glib0 \
	libsndio-dev libsystemd-dev libudev-dev libxss-dev libxt-dev libxv-dev libxxf86vm-dev"
fi

patchlevel="20240222.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove x42-plugins
	apt -y install fonts-freefont-ttf libglu-dev libftgl-dev
	#$ZYNTHIAN_RECIPE_DIR/install_x42_plugins.sh => It's done in 20240501
fi

patchlevel="20240222.2"
# Dropped!

patchlevel="20240222.3"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	echo "deb https://deb.zynthian.org/zynthian-testing bookworm main" > "/etc/apt/sources.list.d/zynthian.list"
	res=`dpkg -s libsndfile1-dev 2>&1 | grep "Status:"`
	if [ "$res" == "Status: install ok installed" ]; then
		apt -y remove libsndfile1-dev
	fi
	res=`dpkg -s libsndfile1-zyndev 2>&1 | grep "Status:"`
	if [ "$res" == "Status: install ok installed" ]; then
		apt -y remove libsndfile1-zyndev
	fi
	aptpkgs="$aptpkgs libsndfile-zyndev"
fi

patchlevel="20240222.4"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	echo "opensynth" | vncpasswd -f > /root/.vnc/passwd
	chmod go-r /root/.vnc/passwd
	aptpkgs="$aptpkgs x11vnc"
fi

patchlevel="20240225.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	systemctl disable glamor-test.service
	rm -f /usr/share/X11/xorg.conf.d/20-noglamor.conf
fi

patchlevel="20240227.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	pip3 install xstatic XStatic_term.js
fi

patchlevel="20240228.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs xserver-xorg-input-evdev"
fi

patchlevel="20240305.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs xfce4-terminal"
fi

patchlevel="20240308.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt-get -y remove zynaddsubfx zynaddsubfx-data
	apt-get -y install -t bookworm zynaddsubfx
	apt-mark hold zynaddsubfx
fi

patchlevel="20240308.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	rm -rf $ZYNTHIAN_SW_DIR/browsepy
	$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
fi

patchlevel="20240313.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs sooperlooper"
fi

#patchlevel="20240325.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	cd $ZYNTHIAN_UI_DIR/zyngine
#	./zynthian_lv2.py presets https://github.com/michaelwillis/dragonfly-reverb
#	./zynthian_lv2.py presets urn:dragonfly:plate
#	./zynthian_lv2.py presets urn:dragonfly:room
#fi

patchlevel="20240325.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	echo "deb https://deb.zynthian.org/zynthian-oram bookworm-oram main" > "/etc/apt/sources.list.d/zynthian.list"
	apt -y update
	apt -y install -t bookworm-oram jamulus
fi

patchlevel="20240404.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	pip3 install adafruit-circuitpython-neopixel-spi
fi

patchlevel="20240409.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs shiro-plugins safe-plugins sorcer"
fi

patchlevel="20240416.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	#rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/sooperlooper.lv2
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/b_synth.lv2
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Pianoteq*.lv2
	rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/Pianoteq*
fi

patchlevel="20240416.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove avldrums.lv2 avldrums.lv2-data
	$ZYNTHIAN_RECIPE_DIR/install_avldrums.sh
fi

#patchlevel="20240419.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	$ZYNTHIAN_RECIPE_DIR/install_mimi.sh
#	cd $ZYNTHIAN_UI_DIR/zyngine
#	./zynthian_lv2.py engines
#	./zynthian_lv2.py presets https://butoba.net/homepage/mimid.html
#	set_restart_ui_flag
#fi

patchlevel="20240419.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_surge_xt_prebuilt.sh
	set_restart_ui_flag
fi

patchlevel="20240421.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_monique_monosynth_prebuilt.sh
	set_restart_ui_flag
fi

patchlevel="20240421.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	mkdir "/root/.Surge XT"
	$ZYNTHIAN_RECIPE_DIR/install_odin2_prebuilt.sh
	set_restart_ui_flag
fi

#patchlevel="20240422.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	#echo "Applying patch $patchlevel ..."
	#SKIP_WARNING=1 rpi-update
#fi

patchlevel="20240423.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	rm -f $ZYNTHIAN_DATA_DIR/soundfonts/sf2/*\**
fi

patchlevel="20240501.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_x42_plugins.sh
fi

patchlevel="20240501.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y install faust
	$ZYNTHIAN_RECIPE_DIR/install_faust_lv2.sh
fi

patchlevel="20240504.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	rm -rf /etc/systemd/system/bluetooth.service.d
fi

patchlevel="20240504.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove hostapd
	#systemctl disable avahi-daemon
	#systemctl stop avahi-daemon
fi

patchlevel="20240508.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	systemctl enable avahi-daemon
	systemctl start avahi-daemon
fi

patchlevel="20240517.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove surge
fi

patchlevel="20240521.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	if [[ "$ZYNTHIAN_OS_VERSION" == "2403" ]]; then
		echo "Bump ZynthianOS version to 2405"
		echo "2405" > /etc/zynthianos_version
	fi
fi

patchlevel="20240522.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_jackrtpmidid.sh
fi

patchlevel="20240522.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_aeolus.sh
fi

patchlevel="20240525.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	rm /zynthian/zynthian-my-data/presets/aeolus.json
fi

patchlevel="20240526.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove pyliblo-utils
	$ZYNTHIAN_RECIPE_DIR/install_pyliblo.sh
	$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh
fi

patchlevel="20240528.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_mimi.sh
	cd $ZYNTHIAN_UI_DIR/zyngine
	./zynthian_lv2.py engines
	./zynthian_lv2.py presets https://butoba.net/homepage/mimid.html
	set_restart_ui_flag
fi

#patchlevel="20240604.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	pip3 install hwmon vcgencmd
#fi

patchlevel="20240610.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	if [ ! -d "$ZYNTHIAN_SW_DIR/noVNC" ]; then
		$ZYNTHIAN_RECIPE_DIR/install_noVNC.sh
	fi
fi

patchlevel="20240611.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove bluez
	aptpkgs="$aptpkgs zynbluez"
	#apt -y install libical-dev docutils-common
	#$ZYNTHIAN_RECIPE_DIR/install_bluez.sh
fi

patchlevel="20240613.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs python3-pam"
fi

patchlevel="20240616.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_aidax.sh
fi

patchlevel="20240626.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	if [[ "$ZYNTHIAN_OS_VERSION" == "2405" ]]; then
		echo "Bump ZynthianOS version to 2406"
		echo "2406" > /etc/zynthianos_version
		# Update build date, forgot in last image ;-)
		ts=$(stat "/zynthian/zynthian-sw/noVNC" -c %w | cut -d " " -f 1,2)
		if [[ "$ts" == "2024-06-25 17:06:50.074846744" ]]; then
			sed -i "s/2024-05-21/2024-06-25/" $ZYNTHIAN_DIR/build_info.txt
		fi
	fi
	if [ -f "$ZYNTHIAN_SW_DIR/plugins/AIDA-X-1.1.0-linux-arm64.tar.xz" ]; then
		rm -f "$ZYNTHIAN_SW_DIR/plugins/AIDA-X-1.1.0-linux-arm64.tar.xz"
	fi
fi

patchlevel="20240626.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	cd $ZYNTHIAN_UI_DIR/zyngine
	./zynthian_lv2.py presets https://github.com/michaelwillis/dragonfly-reverb
	./zynthian_lv2.py presets urn:dragonfly:plate
	./zynthian_lv2.py presets urn:dragonfly:room
fi

patchlevel="20240829.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	systemctl mask rpi-eeprom-update
fi

patchlevel="20240902.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
  $ZYNTHIAN_RECIPE_DIR/install_mimi.sh
	cd $ZYNTHIAN_UI_DIR/zyngine
	./zynthian_lv2.py presets https://butoba.net/homepage/mimid.html
	aptpkgs="$aptpkgs regrader"
fi

patchlevel="20240910.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
  $ZYNTHIAN_RECIPE_DIR/install_dexed_prebuilt.sh
fi

patchlevel="20240910.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	systemctl unmask rpi-eeprom-update
	systemctl enable rpi-eeprom-update
	SKIP_WARNING=1 rpi-update
	#$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh
fi

patchlevel="20240911.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt-get -y install -t bookworm zynaddsubfx-lv2
	apt-mark hold zynaddsubfx-lv2
fi

patchlevel="20240912.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	if [[ ! -d "$ZYNTHIAN_SW_DIR/pianoteq" ]]; then
		if [[ -d "$ZYNTHIAN_SW_DIR/pianoteq6" ]]; then
			mv $ZYNTHIAN_SW_DIR/pianoteq6 $ZYNTHIAN_SW_DIR/pianoteq
		fi
	fi
	ptinfo=${"$ZYNTHIAN_SW_DIR/pianoteq/pianoteq --version"}
	if [[ "$ptinfo" = *@(Trial version)* ]]; then
		if [[ "$ptinfo" != *@(version 8.3.1)* ]]; then
			$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh
		fi
	fi
fi

# 2024-01-08: Install alsa-midi (chain_manager)
#if is_python_module_installed.py alsa-midi; then
#	pip3 install alsa-midi
#fi

# -----------------------------------------------------------------------------
# Patches to ORAM stable release
# -----------------------------------------------------------------------------

patchlevel="20240926"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
  $ZYNTHIAN_RECIPE_DIR/install_patchage.sh
fi

patchlevel="20240928"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	systemctl stop dhcpcd
	systemctl disable dhcpcd
	aptpkgs="$aptpkgs pd-ambix pd-autopreset pd-cmos pd-creb pd-deken pd-deken-apt pd-extendedview pd-flext-dev pd-flext-doc pd-gil \
pd-hexloader pd-iem pd-jsusfx pd-kollabs pd-lib-builder pd-log pd-mediasettings pd-mrpeach-net pd-nusmuk pd-pan \
pd-pduino pd-pool pd-puremapping pd-purest-json pd-rtclib pd-slip pd-syslog pd-tclpd pd-testtools pd-unauthorized \
pd-upp pd-xbee pd-xsample"
fi

patchlevel="20241015"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
  $ZYNTHIAN_RECIPE_DIR/install_qmidiarp_prebuilt.sh
fi

patchlevel="20241016"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	sbdir="/root/.local/share/odin2/Soundbanks"
	if [ ! -d "$sbdir" ]; then
  	mkdir "$sbdir"
	fi
fi

patchlevel="20241022.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
  $ZYNTHIAN_RECIPE_DIR/install_lv2-gtk-ui-bridge.sh
fi

patchlevel="20241022.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	if [ ! -d "/root/.helm" ]; then
		mkdir "/root/.helm"
	fi
	echo '{
  "synth_version": "0.9.0",
  "day_asked_for_payment": 19989,
  "should_ask_for_payment": false,
  "animate_widgets": false
}' > /root/.helm/Helm.config
fi

patchlevel="20241022.3"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt-get -y install ttf-bitstream-vera
	$ZYNTHIAN_RECIPE_DIR/install_setbfree.sh
fi

patchlevel="20241024.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs riban-lv2"
fi

# Force to tag-release
patchlevel="20241105.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	cd $ZYNTHIAN_SYS_DIR
	sys_branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
	if [[ "$sys_branch" == "$ZYNTHIAN_STABLE_BRANCH" ]]; then
  	set_envar.py ZYNTHIAN_STABLE_TAG last
  	export ZYNTHIAN_STABLE_TAG="last"
  fi
fi

patchlevel="20241111.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_dsp56300_prebuilt.sh
fi

patchlevel="20241113.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_tkinterweb.sh
	# Setup new ALT button functionality
	set_envar.py ZYNTHIAN_WIRING_CUSTOM_SWITCH_05 UI_ACTION_RELEASE
	set_envar.py ZYNTHIAN_WIRING_CUSTOM_SWITCH_05__UI_SHORT TOGGLE_ALT_MODE
	set_envar.py ZYNTHIAN_WIRING_CUSTOM_SWITCH_05__UI_BOLD HELP
fi

patchlevel="20241120.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	pip3 install pyalsaaudio
fi

patchlevel="20241206.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel..."
	dpkg-reconfigure linux-image-`uname -r`
fi

patchlevel="20241213.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_Perfomix_prebuilt.sh
fi

patchlevel="20241220.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv_asyncli.sh
fi

patchlevel="20241222.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_jc103_prebuilt.sh
fi

# -----------------------------------------------------------------------------
# End of patches section
# -----------------------------------------------------------------------------

echo "END OF PATCHES"

# -----------------------------------------------------------------------------
# Install selected debian packages
# -----------------------------------------------------------------------------

# Unhold some packages
#apt-mark unhold raspberrypi-kernel
#apt-mark unhold raspberrypi-sys-mods

# Install needed apt packages
if [ "$aptpkgs" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y install $aptpkgs
fi

# -----------------------------------------------------------------------------
# Save current patch level
# -----------------------------------------------------------------------------

if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "$patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
else
	echo "NO NEW PATCHES TO APPLY."
fi

# -----------------------------------------------------------------------------
# Upgrade System
# -----------------------------------------------------------------------------

if [[ "$ZYNTHIAN_SYS_BRANCH" == "$ZYNTHIAN_TESTING_BRANCH" || "$ZYNTHIAN_FORCE_APT_UPGRADE" == "yes" ]]; then
	echo "UPGRADING DEBIAN PACKAGES ..."
	if [ -z "$aptpkgs" ]; then
		apt-get -y update --allow-releaseinfo-change
	fi
	#dpkg --configure -a # => Recover from broken upgrade
	apt-get -y upgrade
fi

# -----------------------------------------------------------------------------
# Clean apt packages
# -----------------------------------------------------------------------------

apt-get -y autoremove
apt-get -y autoclean

# -----------------------------------------------------------------------------
# Bizarre stuff that shouldn't be needed but sometimes is
# -----------------------------------------------------------------------------

# Reinstall kernel and firmware to latest stable version
#apt-get install --reinstall raspberrypi-bootloader raspberrypi-kernel

# Update firmware to a recent version that works OK
#SKIP_WARNING=1 rpi-update rpi-6.6.y

#------------------------------------------------------------------------------

run_flag_actions

#------------------------------------------------------------------------------

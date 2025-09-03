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
	current_patchlevel="20240912.1"
	echo "$current_patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
fi

echo "Current patch level: $current_patchlevel"

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
	apt -y install ttf-bitstream-vera
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

#patchlevel="20241111.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	$ZYNTHIAN_RECIPE_DIR/install_dsp56300_prebuilt.sh
#fi

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

patchlevel="20241222.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_jc303_prebuilt.sh
fi

patchlevel="20250104.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_Perfomix_prebuilt.sh
	regenerate_lv2_presets.sh lv2://nobisoft.de/Perfomix
fi

patchlevel="20250108.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_nam_prebuilt.sh
fi

patchlevel="20250110.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv_asyncli.sh
fi

patchlevel="20250204.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_jacknetumpd.sh
fi

patchlevel="20250204.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_mimid_prebuilt.sh
	regenerate_lv2_presets.sh https://butoba.net/homepage/mimid.html
fi

patchlevel="20250212.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_ratatouille_prebuilt.sh
fi

#patchlevel="20250214.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	$ZYNTHIAN_RECIPE_DIR/install_TAL-U-NO-LX-V2_prebuilt.sh
#fi

patchlevel="20250218.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_ripplerx_prebuilt.sh
fi

#patchlevel="20250228.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	apt -y remove fabla
#	$ZYNTHIAN_RECIPE_DIR/install_fabla_prebuilt.sh
#fi

patchlevel="20250310.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_filebrowser.sh
	systemctl enable filebrowser
	systemctl start filebrowser
fi

patchlevel="20250310.3"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs python3-bcrypt"
fi

patchlevel="20250312.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	if [ ! -L "$ZYNTHIAN_SW_DIR/filebrowser/root/media" ]; then
		ln -s /media "$ZYNTHIAN_SW_DIR/filebrowser/root/media"
	fi
fi

patchlevel="20250320.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_vlc.sh
fi

patchlevel="20250428.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	cd $ZYNTHIAN_SW_DIR/jalv_asyncli/build
	meson install
fi

patchlevel="20250527.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_novachord_prebuilt.sh
fi

patchlevel="20250604.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_TAL-U-NO-LX-V2_prebuilt.sh
fi

patchlevel="20250604.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_dsp56300_prebuilt.sh
fi

patchlevel="20250605.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	cd $ZYNTHIAN_SW_DIR/jalv_asyncli
	git pull
	cd build
	meson compile -j 3
	meson install
fi

patchlevel="20250611.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove zynaddsubfx-lv2
fi

patchlevel="20250611.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	ZYNTHIAN_FORCE_APT_UPGRADE="yes"
fi

patchlevel="20250810.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	aptpkgs="$aptpkgs libwebkit2gtk-4.0-dev"
	$ZYNTHIAN_RECIPE_DIR/install_OB-Xf_prebuilt.sh
fi

patchlevel="20250810.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	apt -y remove fabla
	$ZYNTHIAN_RECIPE_DIR/install_fabla_prebuilt.sh
fi

patchlevel="20250828.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_jv880_prebuilt.sh
fi

patchlevel="20250828.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_autoleveler_prebuilt.sh
fi

patchlevel="20250903.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "Applying patch $patchlevel ..."
	cd "/usr/local/lib/lv2/Surge XT.lv2"
	rm -f "factory_presets.ttl"
	wget "https://os.zynthian.org/plugins/aarch64/Surge XT.lv2/factory_presets.ttl"
	regenerate_lv2_presets.sh https://surge-synthesizer.github.io/lv2/surge-xt
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
	apt -y update --allow-releaseinfo-change
	apt -y install $aptpkgs
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
		apt -y update --allow-releaseinfo-change
	fi
	#dpkg --configure -a # => Recover from broken upgrade
	apt -y upgrade
fi

# -----------------------------------------------------------------------------
# Clean apt packages
# -----------------------------------------------------------------------------

apt -y autoremove
apt -y autoclean

# -----------------------------------------------------------------------------
# Bizarre stuff that shouldn't be needed but sometimes is
# -----------------------------------------------------------------------------

# Reinstall kernel and firmware to latest stable version
#apt install --reinstall raspberrypi-bootloader raspberrypi-kernel

# Update firmware to a recent version that works OK
#SKIP_WARNING=1 rpi-update rpi-6.6.y

#------------------------------------------------------------------------------

run_flag_actions

#------------------------------------------------------------------------------

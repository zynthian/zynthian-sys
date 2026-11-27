#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Run Update Recipes
#
# Run the scripts contained in recipes.update directory
#
# Copyright (C) 2015-2026 Fernando Moyano <jofemodo@zynthian.org>
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
# Enable strict mode and Catch errors with trap
#------------------------------------------------------------------------------

set -euo pipefail
set -o errtrace
#IFS=$'\n\t'

function catch_error {
	echo "Error Catched! Aborting Zynthian Update ...";
	exit 1
}

trap "catch_error" ERR

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
	current_patchlevel="20261014.1"
	echo "$current_patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
fi

echo "Current patch level: $current_patchlevel"

# Most patches install prebuilt binaries, only available for aarch64 (RBPi >= 3).
# Other architectures (e.g. x86_64 containers) only get the patches flagged with "all".
if [[ "$MACHINE_HW_NAME" == "aarch64" ]] && ! [[ "$RBPI_VERSION_NUMBER" =~ ^[0-9]+$ && "$RBPI_VERSION_NUMBER" -lt 3 ]]; then
	prebuilt_patches="1"
else
	prebuilt_patches="0"
	echo "Only patches for all architectures will be applied => Prebuilt binaries are only available for aarch64!"
fi

# Check if a patch must be applied. It sets "patchlevel", so the last patch level is saved at the end.
#   $1: patch level
#   $2: "all" => apply in all architectures. By default, patches are applied only if prebuilt_patches=1
function apply_patch {
	patchlevel="$1"
	if [[ ! "$current_patchlevel" < "$patchlevel" ]]; then
		return 1
	fi
	if [[ "${2:-}" != "all" && "$prebuilt_patches" != "1" ]]; then
		echo "Skipping patch $patchlevel => Only for aarch64"
		return 1
	fi
	echo "Applying patch $patchlevel ..."
	return 0
}

# -----------------------------------------------------------------------------
# Patches to ORAM
# -----------------------------------------------------------------------------

if apply_patch "20241222.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_jc303_prebuilt.sh
	regenerate_lv2_presets.sh "http://github.com/midilab/JC303"
fi

if apply_patch "20250104.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_Perfomix_prebuilt.sh
	regenerate_lv2_presets.sh "lv2://nobisoft.de/Perfomix"
fi

if apply_patch "20250204.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_jacknetumpd.sh
fi

if apply_patch "20250527.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_novachord_prebuilt.sh
fi

if apply_patch "20250604.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_TAL-U-NO-LX-V2_prebuilt.sh
fi

if apply_patch "20250828.2"; then
	$ZYNTHIAN_RECIPE_DIR/install_autoleveler_prebuilt.sh
fi

if apply_patch "20250903.1"; then
	cd "/usr/local/lib/lv2/Surge XT.lv2"
	rm -f "factory_presets.ttl"
	wget "https://os.zynthian.org/plugins/aarch64/Surge XT.lv2/factory_presets.ttl"
	regenerate_lv2_presets.sh "https://surge-synthesizer.github.io/lv2/surge-xt"
fi

if apply_patch "20250910.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_jv880_prebuilt.sh
fi

if apply_patch "20250912.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_CloudReverb_prebuilt.sh
fi

if apply_patch "20251001.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_mod-mda_prebuilt.sh
fi

if apply_patch "20251003.1"; then
	apt-get -y remove klangfalter-lv2
fi

if apply_patch "20251004.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_lv2-gtk-ui-bridge.sh
fi

if apply_patch "20251006.1"; then
	apt-get -y remove drmr
	$ZYNTHIAN_RECIPE_DIR/install_drmr_prebuilt.sh
fi

if apply_patch "20251007.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_x42_zeroconvo_prebuilt.sh
fi

if apply_patch "20251021.1"; then
	apt-get -y remove fabla
	$ZYNTHIAN_RECIPE_DIR/install_fabla_prebuilt.sh
fi

if apply_patch "20251230.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_zynMI_prebuilt.sh
fi

if apply_patch "20251230.2"; then
	$ZYNTHIAN_RECIPE_DIR/install_CHOWTapeModel_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_CHOWPhaser_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_CHOWCentaur_prebuilt.sh
fi

if apply_patch "20251230.3"; then
	$ZYNTHIAN_RECIPE_DIR/install_roboverb_prebuilt.sh
fi

if apply_patch "20260112.2"; then
	$ZYNTHIAN_RECIPE_DIR/install_TheUsualSuspects_prebuilt.sh
fi

if apply_patch "20260122.1"; then
	# Reinstall vlc with post-install hook to patch to allow root user
	$ZYNTHIAN_RECIPE_DIR/install_vlc.sh
fi

if apply_patch "20260129.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_qmidiarp_prebuilt.sh
fi

if apply_patch "20260228.2"; then
	$ZYNTHIAN_RECIPE_DIR/install_ripplerx_prebuilt.sh
fi

if apply_patch "20260416.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_Ultramaster_KR-106_prebuilt.sh
fi

if apply_patch "20260608.1"; then
	# Update Neural Modelers
	$ZYNTHIAN_RECIPE_DIR/install_nam_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_ratatouille_prebuilt.sh
	# Install NeuralRack
	$ZYNTHIAN_RECIPE_DIR/install_neuralrack_prebuilt.sh
fi

if apply_patch "20260728.2"; then
	$ZYNTHIAN_SYS_DIR/sbin/autoconfig_plymouth_theme.sh
fi

if apply_patch "20260811.1"; then
	ptq_version=$($ZYNTHIAN_SW_DIR/pianoteq/pianoteq --version | head -n 1)
	ptq_version_parts=($ptq_version)
	if [[ "${ptq_version_parts[2]}" == "Trial" && "${ptq_version_parts[4]}" < "9.2.1" ]]; then
		$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh
	fi
fi

# Update MiMid.lv2 plugin
if apply_patch "20260915.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_mimid_prebuilt.sh
	regenerate_lv2_presets.sh "https://butoba.net/homepage/mimid.html"
fi

# Update Perfomix.lv2 plugin
if apply_patch "20260916.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_Perfomix_prebuilt.sh
fi

# Install Dusk-Audio plugins
if apply_patch "20260917.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_dusk_4K_EQ2_prebuilt.sh
	#$ZYNTHIAN_RECIPE_DIR/install_dusk_chord_analyzer_headless_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_chord_analyzer_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_duskverb_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_multi_comp_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_multi_Q_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_spectrum_analyzer_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_sunset_circuits_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_tape_echo2_prebuilt.sh
	$ZYNTHIAN_RECIPE_DIR/install_dusk_tapemachine2_prebuilt.sh
fi
if apply_patch "20260917.2"; then
	apt-get -y install patchelf
	$ZYNTHIAN_RECIPE_DIR/install_dusk_chord_analyzer_headless_prebuilt.sh
fi

# Install the Airwindows family of plugins (LV2)
if apply_patch "20260922.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_airwindows-lv2_prebuilt.sh
fi

# Update riban plugins (LV2)
if apply_patch "20261001.1"; then
	apt-get -y remove riban-lv2 || true
	$ZYNTHIAN_RECIPE_DIR/install_riban-lv2_prebuilt.sh
fi

# Update OB-Xf (LV2)
if apply_patch "20261002.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_OB-Xf_prebuilt.sh
	regenerate_lv2_presets.sh "urn:org.surge-synth-team.OB-Xf"
fi

# Install the guitaramp-suite family of plugins (LV2)
if apply_patch "20261014.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_guitaramp-suite_prebuilt.sh
fi

# -----------------------------------------------------------------------------
# Patches to VANGELIS
# -----------------------------------------------------------------------------

# Regenerate LV2 presets for fabla & DrMr to fix drumkit paths
if apply_patch "20261016.1"; then
	generate_lv2_presets_hydrogen2fabla.py
	generate_lv2_presets_DrMr.py
	pushd $ZYNTHIAN_UI_DIR/zyngine
	./zynthian_lv2.py presets "http://www.openavproductions.com/fabla" "http://github.com/nicklan/drmr"
	popd
fi

# Install/update faust-plugins (LV2)
if apply_patch "20261028.1"; then
	$ZYNTHIAN_RECIPE_DIR/install_faust-plugins_prebuilt.sh
fi

# Install websocket-server library for python
if apply_patch "20261111.1" all; then
	pip3 install websocket-server
fi

# Replace the aubionotes service with the audio to MIDI converter (zynthian-ui global processor)
if apply_patch "20261127.2" all; then
	systemctl stop aubionotes 2> /dev/null || true
	systemctl disable aubionotes 2> /dev/null || true
	rm -f /etc/systemd/system/aubionotes.service
	systemctl daemon-reload || true
	rm -f /usr/local/bin/aubiomfcc /usr/local/bin/aubionotes /usr/local/bin/aubioonset /usr/local/bin/aubiopitch /usr/local/bin/aubioquiet /usr/local/bin/aubiotrack
	rm -f /usr/local/lib/libaubio*
	ldconfig || true
	# MIDI profiles: the aubionotes enable becomes the audio to MIDI converter enable
	for profile in "$ZYNTHIAN_CONFIG_DIR"/midi-profiles/*.sh; do
		[ -f "$profile" ] || continue
		if grep -q "ZYNTHIAN_MIDI_AUDIO2MIDI_ENABLED" "$profile"; then
			sed -i -e "/ZYNTHIAN_MIDI_AUBIONOTES_ENABLED/d" "$profile"
		else
			sed -i -e "s/ZYNTHIAN_MIDI_AUBIONOTES_ENABLED/ZYNTHIAN_MIDI_AUDIO2MIDI_ENABLED/" "$profile"
		fi
	done
	if [ -f "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" ]; then
		sed -i -e "/ZYNTHIAN_AUBIONOTES_OPTIONS/d" "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
	fi
fi

# -----------------------------------------------------------------------------
# Template Patches
# -----------------------------------------------------------------------------

# Pave the way for wayland => Not yet!!
#patchlevel="20260806.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	aptpkgs="$aptpkgs labwc xwayland swaybg"
#fi

# Force to tag-release
#patchlevel="20241105.1"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	cd $ZYNTHIAN_SYS_DIR
#	sys_branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
#	if [[ "$sys_branch" == "$ZYNTHIAN_STABLE_BRANCH" ]]; then
#		set_envar.py ZYNTHIAN_STABLE_TAG last
#		export ZYNTHIAN_STABLE_TAG="last"
#	fi
#fi

# Force apt upgrade on stable
#patchlevel="20251105.2"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	ZYNTHIAN_FORCE_APT_UPGRADE="yes"
#fi

# Force regeneration of UI images
#patchlevel="20260319.2"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	rm -f /zynthian/config/img/*
#fi

# TODO This should be moved to a proper install script- It's too complex for a recipe and can fail ...
#patchlevel="20260208.4"
#if [[ "$current_patchlevel" < "$patchlevel" ]]; then
#	echo "Applying patch $patchlevel ..."
#	curl -s https://kopia.io/signing-key | gpg --dearmor --batch --yes -o /etc/apt/keyrings/kopia-keyring.gpg
#	echo "deb [signed-by=/etc/apt/keyrings/kopia-keyring.gpg] http://packages.kopia.io/apt/ stable main" | tee /etc/apt/sources.list.d/kopia.list
#	aptpkgs="$aptpkgs sshpass kopia"
#fi

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
# Disable strict mode and error trap
# -----------------------------------------------------------------------------

set +eu
trap - ERR

# -----------------------------------------------------------------------------
# Upgrade System
# -----------------------------------------------------------------------------

if [[ "$ZYNTHIAN_SYS_BRANCH" == "$ZYNTHIAN_TESTING_BRANCH" || "$ZYNTHIAN_FORCE_APT_UPGRADE" == "yes" ]]; then
	echo "UPGRADING DEBIAN PACKAGES ..."
	if [ -z "$aptpkgs" ]; then
		apt-get -y update --allow-releaseinfo-change
	fi
	#dpkg --configure -a # => Recover from broken upgrade
	#apt-get -y upgrade
	apt-get -y dist-upgrade
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



aptpkgs=""

# -----------------------------------------------------------------------------
# Load current patchlevel
# -----------------------------------------------------------------------------

if [ -f "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt" ]; then
	current_patchlevel=$(cat "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt")
else
	current_patchlevel="20240220.1"
	echo "$current_patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
fi

# -----------------------------------------------------------------------------
# Temporal fixes to patch development image until final ORAM release
# -----------------------------------------------------------------------------

patchlevel="20240221.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "set enable-bracketed-paste off" > /root/.inputrc
	$ZYNTHIAN_RECIPE_DIR/install_dexed_lv2.sh
	$ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
fi


# 2024-01-08: Install alsa-midi (chain_manager)
#if is_python_module_installed.py alsa-midi; then
#	pip3 install alsa-midi
#fi

# 2024-01-08: Install python3-usb (chain_manager)
#res=`dpkg -s python3-usb 2>&1 | grep "Status:"`
#if [ "$res" != "Status: install ok installed" ]; then
#	aptpkgs="$aptpkgs python3-usb"
#fi

# -----------------------------------------------------------------------------
# Install/update recipes shouldn't be added below this line!
# -----------------------------------------------------------------------------

# Unhold some packages
#apt-mark unhold raspberrypi-kernel
#apt-mark unhold raspberrypi-sys-mods

# Install needed apt packages
if [ ! -z "$aptpkgs" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y install $aptpkgs
fi

# Upgrade System
if [[ ! "$ZYNTHIAN_SYS_BRANCH" =~ ^stable.* ]] || [[ "$ZYNTHIAN_FORCE_UPGRADE" == "yes" ]]; then
	if [ -z "$aptpkgs" ]; then
		apt-get -y update --allow-releaseinfo-change
	fi
	#dpkg --configure -a # => Recover from broken upgrade
	apt-get -y upgrade
fi

apt-get -y autoremove
apt-get -y autoclean

# Reinstall firmware to latest stable version
#apt-get install --reinstall raspberrypi-bootloader raspberrypi-kernel

# Update firmware to a recent version that works OK!!
#if [[ "$VIRTUALIZATION" == "none" ]] && [[ "$LINUX_KERNEL_VERSION" < "5.15.61-v7l+" ]]; then
	#echo "LINUX KERNEL VERSION: $LINUX_KERNEL_VERSION"
	#SKIP_WARNING=1 rpi-update
	#set_reboot_flag
#fi

# Install a firmware version that works OK!!
#if [[ "$LINUX_KERNEL_VERSION" != "5.10.49-v7l+" ]]; then
#	rpi-update -y dc6dc9bc6692d808fcce5ace9d6209d33d5afbac
#	set_reboot_flag
#fi

# -----------------------------------------------------------------------------
# Save current patch level
# -----------------------------------------------------------------------------

echo "$patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"

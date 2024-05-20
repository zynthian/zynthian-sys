
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

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

# This should be removed in the next weeks ...
# Fix typo in patchlevel => DISASTER!!!
if [[ "$current_patchlevel" == "20240515.3" ]]; then
	current_patchlevel="20240415.3"
fi

echo "CURRENT PATCH LEVEL: $current_patchlevel"

# -----------------------------------------------------------------------------
# Temporal patches to development image until final ORAM release
# -----------------------------------------------------------------------------

patchlevel="20240221.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	echo "set enable-bracketed-paste off" > /root/.inputrc
	$ZYNTHIAN_RECIPE_DIR/install_dexed_lv2.sh
	$ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
fi

patchlevel="20240221.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
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
	echo "APPLYING PATCH $patchlevel ..."
	apt -y remove x42-plugins
	apt -y install fonts-freefont-ttf libglu-dev libftgl-dev
	#$ZYNTHIAN_RECIPE_DIR/install_x42_plugins.sh => It's done in 20240501
fi

patchlevel="20240222.2"
# Dropped!

patchlevel="20240222.3"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
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
	echo "APPLYING PATCH $patchlevel ..."
	echo "opensynth" | vncpasswd -f > /root/.vnc/passwd
	chmod go-r /root/.vnc/passwd
	aptpkgs="$aptpkgs x11vnc"
fi

patchlevel="20240225.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	systemctl disable glamor-test.service
	rm -f /usr/share/X11/xorg.conf.d/20-noglamor.conf
fi

patchlevel="20240227.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	pip3 install xstatic XStatic_term.js
fi

patchlevel="20240228.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs xserver-xorg-input-evdev"
fi

patchlevel="20240305.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs xfce4-terminal"
fi

patchlevel="20240308.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt-get -y remove zynaddsubfx zynaddsubfx-data
	apt-get -y install -t bookworm zynaddsubfx
	apt-mark hold zynaddsubfx
fi

patchlevel="20240308.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	rm -rf $ZYNTHIAN_SW_DIR/browsepy
	$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
fi

patchlevel="20240313.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs sooperlooper"
fi

patchlevel="20240325.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	cd $ZYNTHIAN_UI_DIR/zyngine
	./zynthian_lv2.py presets https://github.com/michaelwillis/dragonfly-reverb
	./zynthian_lv2.py presets urn:dragonfly:plate
	./zynthian_lv2.py presets urn:dragonfly:room
fi

patchlevel="20240325.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	echo "deb https://deb.zynthian.org/zynthian-oram bookworm-oram main" > "/etc/apt/sources.list.d/zynthian.list"
	apt -y update
	apt -y install -t bookworm-oram jamulus
fi

patchlevel="20240404.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	pip3 install adafruit-circuitpython-neopixel-spi
fi

patchlevel="20240409.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs shiro-plugins safe-plugins sorcer"
fi

patchlevel="20240416.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	#rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/sooperlooper.lv2
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/b_synth.lv2
	rm -rf $ZYNTHIAN_PLUGINS_DIR/lv2/Pianoteq*.lv2
	rm -rf $ZYNTHIAN_MY_DATA_DIR/presets/lv2/Pianoteq*
fi

patchlevel="20240416.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt -y remove avldrums.lv2 avldrums.lv2-data
	$ZYNTHIAN_RECIPE_DIR/install_avldrums.sh
fi

patchlevel="20240419.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_mimi.sh
	cd $ZYNTHIAN_UI_DIR/zyngine
	./zynthian_lv2.py engines
	./zynthian_lv2.py presets https://butoba.net/homepage/mimid.html
	set_restart_ui_flag
fi

patchlevel="20240419.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_surge_xt_prebuilt.sh
	set_restart_ui_flag
fi

patchlevel="20240421.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_monique_monosynth_prebuilt.sh
	set_restart_ui_flag
fi

patchlevel="20240421.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	mkdir "/root/.Surge XT"
	$ZYNTHIAN_RECIPE_DIR/install_odin2_prebuilt.sh
	set_restart_ui_flag
fi

patchlevel="20240422.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	SKIP_WARNING=1 rpi-update
fi

patchlevel="20240423.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	rm -f $ZYNTHIAN_DATA_DIR/soundfonts/sf2/*\**
fi

patchlevel="20240501.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	$ZYNTHIAN_RECIPE_DIR/install_x42_plugins.sh
fi

patchlevel="20240501.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt -y install faust
	$ZYNTHIAN_RECIPE_DIR/install_faust_lv2.sh
fi

patchlevel="20240504.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	rm -rf /etc/systemd/system/bluetooth.service.d
fi

patchlevel="20240504.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt -y remove hostapd
	#systemctl disable avahi-daemon
	#systemctl stop avahi-daemon
fi

patchlevel="20240508.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	systemctl enable avahi-daemon
	systemctl start avahi-daemon
fi

patchlevel="20240517.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt -y remove surge
fi

# 2024-01-08: Install alsa-midi (chain_manager)
#if is_python_module_installed.py alsa-midi; then
#	pip3 install alsa-midi
#fi

# -----------------------------------------------------------------------------
# End of patches section
# -----------------------------------------------------------------------------

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

if [[ ! "$ZYNTHIAN_SYS_BRANCH" =~ ^stable.* ]] || [[ "$ZYNTHIAN_FORCE_UPGRADE" == "yes" ]]; then
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

# Reinstall firmware to latest stable version
#apt install --reinstall raspberrypi-bootloader raspberrypi-kernel

# Update firmware to a recent version that works OK
#SKIP_WARNING=1 rpi-update rpi-6.1.y
#SKIP_WARNING=1 rpi-update rpi-6.6.y


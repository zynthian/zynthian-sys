
aptpkgs=""

# 2020-05-19 => mutagen, for audio/mid file metadata (updated 2021-03-20)
if is_python_module_installed.py mutagen; then
	#pip3 install mutagen
	$ZYNTHIAN_RECIPE_DIR/install_mutagen.sh
fi

# 2020-05-31 => Enabled new zynthian-config-on-boot service
systemctl enable zynthian-config-on-boot

# 2020-06-03: Install arpeggiator
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/bg-arpeggiator.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_arpeggiator.sh
fi

# 2020-06-22: Install stereo-mixer
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/stereo-mixer.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_stereo-mixer.sh
fi

# 2020-07-08: Install dexed from new repository
if [ ! -e $ZYNTHIAN_PLUGINS_SRC_DIR/dexed.lv2 ]; then
	rm -rf $ZYNTHIAN_PLUGINS_SRC_DIR/dexed
	$ZYNTHIAN_RECIPE_DIR/install_dexed_lv2.sh
fi

# 2020-07-14: Install surge from pre-built repo
if [ ! -e $ZYNTHIAN_PLUGINS_DIR/lv2/Surge.lv2 ]; then
	$ZYNTHIAN_RECIPE_DIR/install_surge_prebuilt.sh
fi

# 2020-08-10 => exfat support
res=`dpkg -s exfat-utils 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs exfat-utils"
fi

# 2020-09-30 => Install terminado, needed for the new webconf's zynterm
if [ ! -e $ZYNTHIAN_SW_DIR/terminado ]; then
	$ZYNTHIAN_RECIPE_DIR/install_terminado.sh
fi

# 2020-09-30 => Generate SSL self-signed certificate for webconf
SSL_CERT_DIR="$ZYNTHIAN_DIR/zynthian-webconf/cert"
if [ ! -d "$SSL_CERT_DIR" ]; then
	echo "Generating new SSL certificate for 100 years ..."
	mkdir "$SSL_CERT_DIR"
	openssl req -x509 -newkey rsa:4096 -keyout $SSL_CERT_DIR/key.pem -out $SSL_CERT_DIR/cert.pem -days 36500 -nodes -subj "/CN=`hostname`.local"
fi

# 2020-10-13 => Instal alo looper
if [ ! -e "/usr/local/lib/lv2/alo.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_alo.sh
fi

# 2020-10-13 => Instal VL1 (Casiotone Emulator)
if [ ! -e "/usr/local/lib/lv2/vl1.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_VL1.sh
fi

# 2020-10-13 => Install VL53L0X library (Distance Sensor)
if [ ! -e $ZYNTHIAN_SW_DIR/VL53L0X ]; then
	$ZYNTHIAN_RECIPE_DIR/install_VL53L0X.sh
fi

# 2020-10-26: Install QMidiArp from repo
if [ ! -d "/usr/local/lib/lv2/qmidiarp_arp.lv2" ]; then
	res=`dpkg -s qmidiarp 2>&1 | grep "Status:"`
	if [ "$res" != "Status: install ok installed" ]; then
		aptpkgs="$aptpkgs qmidiarp"
	fi
fi

# 2021-01-03: Install python3-evdev
res=`dpkg -s python3-evdev 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs python3-evdev"
fi

# 2021-02-01: Install vnc4server
res=`dpkg -s vnc4server 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs vnc4server"
fi

# 2021-02-07: Install MCP4728 library (Analog Ouput / CV-OUT)
if [ ! -d "$ZYNTHIAN_SW_DIR/MCP4728" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_MCP4728.sh
fi

# 2021-02-08: Install noVNC web viewer
if [ ! -d "$ZYNTHIAN_SW_DIR/noVNC" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_noVNC.sh
fi

# 2021-02-01: Install xfwm4
res=`dpkg -s xfwm4 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs xfwm4"
fi

res=`dpkg -s libgtk-3-dev 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs libgtk-3-dev"
fi

# 2021-03-11: Install Surge GUI needed fonts
res=`dpkg -s fonts-lato 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs fonts-lato ttf-mscorefonts-installer"
fi

# 2021-03-15: Install/Update Vitalium-LV2 synth
res=`dpkg -s vitalium-lv2 2>&1 | grep "Version:"`
if [[ "$res" < "Version: 5:20210312.3" ]]; then
	aptpkgs="$aptpkgs vitalium-lv2"
fi

# 2021-03-21: Install xfwm4-panel
res=`dpkg -s xfce4-panel 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs xfce4-panel xfwm4-themes xdotool"
	$ZYNTHIAN_RECIPE_DIR/install_xfce4-panel.sh
fi

# 2021-03-25: Install patchage
res=`dpkg -s patchage 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs patchage"
fi

# 2021-03-25: Install MOD's cabsim-IR-loader
if [ ! -d "$ZYNTHIAN_PLUGINS_SRC_DIR/mod-cabsim-IR-loader" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_mod-cabsim-IR-loader.sh
fi

# 2021-05-18: Unmask polkit & packagekit services
systemctl unmask polkit
systemctl unmask packagekit

# 2021-05-20: Install x11vnc
res=`dpkg -s x11vnc 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
        aptpkgs="$aptpkgs x11vnc"
fi
        
# 2021-05-20: Install zynthian repository & public key
if [ ! -f "/etc/apt/sources.list.d/zynthian.list" ]; then
	apt-key add $ZYNTHIAN_SYS_DIR/etc/apt/pubkeys/zynthian.pub
	cp -a $ZYNTHIAN_SYS_DIR/etc/apt/sources.list.d/* /etc/apt/sources.list.d
fi

# 2021-05-20: Upgrade alsa-utils to 1.2.4
res=`dpkg -s alsa-utils 2>&1 | grep "Version:"`
if [[ "$res" < "Version: 1.2.4" ]]; then
	aptpkgs="$aptpkgs alsa-utils"
fi

# 2021-06-20: Install riban LV2 plugins from zynthian deb repo
res=`dpkg -s riban-lv2 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
		if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/riban.lv2" ]; then
			rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/riban.lv2"
		fi
        aptpkgs="$aptpkgs riban-lv2"
fi

# 2021-07-09: Install Boops LV2 plugins from zynthian deb repo
res=`dpkg -s boops 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
        aptpkgs="$aptpkgs boops"
fi

# 2021-07-27: Update touchosc2midi bridge
res=`python -c "import touchosc2midi; print(touchosc2midi.__version__)"`
if [[ "$res" < "0.0.11" ]]; then
	$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh
fi

# 2021-08-19: Install Sfizz
if [ ! -d "$ZYNTHIAN_SW_DIR/sfizz" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_sfizz.sh
fi

# 2021-08-22: Install Squishbox SF2 soundfonts
if [ ! -f "$ZYNTHIAN_DATA_DIR/soundfonts/sf2/ModSynth_R1.sf2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_squishbox_sf2.sh
fi

# Hold some packages
apt-mark unhold raspberrypi-kernel
apt-mark unhold raspberrypi-sys-mods

export DEBIAN_FRONTEND=noninteractive

# Install needed apt packages
if [ ! -z "$aptpkgs" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y install $aptpkgs
fi

# Upgrade System
# WARNING => Disable on Stable!!!
if [ -z "$aptpkgs" ]; then
	apt-get -y update --allow-releaseinfo-change
fi
#dpkg --configure -a # => Recover from broken upgrade
apt-get -y upgrade
apt-get -y autoremove
apt-get -y autoclean

# Install a firmware version that works OK!!
#res=`uname -r`
#if [[ "$res" != "5.10.49-v7l+" ]]; then
#	rpi-update -y dc6dc9bc6692d808fcce5ace9d6209d33d5afbac
#	set_reboot_flag
#fi


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
if is_python_module_installed.py terminado; then
	$ZYNTHIAN_RECIPE_DIR/install_terminado.sh
fi

# 2020-09-30 => Generate SSL self-signed certificate for webconf
SSL_CERT_DIR="$ZYNTHIAN_DIR/zynthian-webconf/cert"
if [ ! -d "$SSL_CERT_DIR" ]; then
	echo "Generating new SSL certificate for 100 years..."
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

# 2021-08-22: Install Squishbox SF2 soundfonts
if [ ! -f "$ZYNTHIAN_DATA_DIR/soundfonts/sf2/ModSynth_R1.sf2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_squishbox_sf2.sh
fi

# 2021-08-30: Install Bollie Delay
if [ ! -d "/usr/local/lib/lv2/bolliedelay.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_bolliedelay.sh
fi

# 2021-09-22: Uninstall sfizz if previously installed from source code
if [ -d "$ZYNTHIAN_SW_DIR/sfizz" ]; then
	cd "$ZYNTHIAN_SW_DIR/sfizz/build"
	make uninstall
	cd $ZYNTHIAN_SW_DIR
	rm -rf "./sfizz"
fi

# 2021-12-08 => Install rpi_ws281x (LED control library)
if is_python_module_installed.py rpi_ws281x; then
	pip3 install rpi_ws281x
fi

# 2021-12-13 => Install WiringPi from zynthian repository
res=`grep "zynthian" $ZYNTHIAN_SW_DIR/WiringPi/.git/config`
if [ -z "$res" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_wiringpi.sh
fi

# 2022-05-17 => Install audiowaveform, used by audioplayer widget
res=`dpkg -s audiowaveform 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs audiowaveform"
fi

# 2022-06-07: Delete old sfizz repo, install new one
if [ -f "/etc/apt/sources.list.d/sfizz-dev.list" ]; then
	apt-get -y remove sfizz
	rm -f /etc/apt/sources.list.d/sfizz-dev.list
fi

if [ ! -f "/etc/apt/sources.list.d/sfizz.list" ]; then
	sfizz_url_base="https://download.opensuse.org/repositories/home:/sfztools:/sfizz/Raspbian_10"
	echo "deb $sfizz_url_base/ /" > /etc/apt/sources.list.d/sfizz.list
	curl -fsSL $sfizz_url_base/Release.key | apt-key add -
fi

# 2022-06-07: Install sfizz from repo
res=`dpkg -s sfizz 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs sfizz"
fi

# 2022-07-26: Install sooperlooper from repo
res=`dpkg -s sooperlooper 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs sooperlooper"
fi

# 2022-09-17: Install TalentedHack LV2 plugin (Autotune)
if [ ! -d "/usr/local/lib/lv2/talentedhack.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_talentedhack.sh
fi

# 2022-09-19: Install ddcutil for display configuration control
res=`dpkg -s ddcutil 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs ddcutil"
fi

# 2022-10-24: Install OS-251 LV2 plugin (Synthesizer)
if [ ! -d "$ZYNTHIAN_PLUGINS_DIR/lv2/OS-251.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_lv2_plugins_prebuilt.sh
fi

# 2022-11-2: Install Odin2 LV2 plugin (Synthesizer)
if [ ! -d "$ZYNTHIAN_PLUGINS_DIR/lv2/Odin2.lv2" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_lv2_plugins_prebuilt.sh
fi

# 2022-11-07 Install mp3 support files
res=`dpkg -s libmpg123-0 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs libmpg123-0 libmp3lame0"
fi
#TODO: Remove this when libsndfile 1.1.0 deb available
if [ ! -f "/usr/local/lib/libsndfile.so.1" ]; then
	res=`uname -m`
	if [[ "$res" == "armv7l" ]]; then
		cp -a /zynthian/zynthian-sys/lib/libsndfile.* /usr/local/lib
		cp -a /zynthian/zynthian-sys/bin/sndfile-* /usr/local/bin
	fi
fi

# 2022-11-25 Bump tornado to v4.5 to solve https issues and probably other issues too
pip3 install tornado==4.5

# 2022-12-05 Install cpufrequtils
res=`dpkg -s cpufrequtils 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs cpufrequtils"
fi

# 2023-03-15: Update DT overlays for waveshare displays 
cts=`stat -c '%y' $ZYNTHIAN_SW_DIR/waveshare-dtoverlays`
if [[ "$cts" < "2023-01-01" ]]; then
	$ZYNTHIAN_RECIPE_DIR/install_waveshare-dtoverlays.sh
fi

# 2023-04-21: Install some library dependencies needed for following updates
res=`dpkg -s gslang-tools 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y install libqt5svg5-dev doxygen graphviz glslang-tools
fi

# 2023-04-21: Update qmidinet...
if [ ! -d "$ZYNTHIAN_SW_DIR/qmidinet" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_qmidinet.sh
fi

# 2023-04-21: Update LV2, Lilv, etc. => PENDING OF TESTING!!!
if is_python_module_installed.py meson; then
	#pip3 install meson ninja
	#$ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh
	#$ZYNTHIAN_RECIPE_DIR/install_lvtk.sh
	#$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv.sh
fi

# -----------------------------------------------------------------------------
# Install/update recipes shouldn't be added below this line!
# -----------------------------------------------------------------------------

# Hold some packages
apt-mark unhold raspberrypi-kernel
apt-mark unhold raspberrypi-sys-mods

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

# Update firmware to a recent version that works OK!!
if [[ "$VIRTUALIZATION" == "none" ]] && [[ "$LINUX_KERNEL_VERSION" < "5.15.61-v7l+" ]]; then
	SKIP_WARNING=1 rpi-update
	set_reboot_flag
fi

# Install a firmware version that works OK!!
#if [[ "$LINUX_KERNEL_VERSION" != "5.10.49-v7l+" ]]; then
#	rpi-update -y dc6dc9bc6692d808fcce5ace9d6209d33d5afbac
#	set_reboot_flag
#fi


aptpkgs=""

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

# 2023-05-29: Update deb.zynthian.org GPG public key
if [ ! -f "/etc/apt/trusted.gpg.d/deb-zynthian-org.gpg" ]; then
	sudo apt-key del 97850188C442336A
	wget -O - https://deb.zynthian.org/deb-zynthian-org.gpg > /etc/apt/trusted.gpg.d/deb-zynthian-org.gpg
fi

# 2023-04-21: Install some library dependencies needed for following updates
res=`dpkg -s glslang-tools 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y install libqt5svg5-dev doxygen graphviz glslang-tools
fi

# 2023-04-21: Update qmidinet...
if [ ! -d "$ZYNTHIAN_SW_DIR/qmidinet" ]; then
	$ZYNTHIAN_RECIPE_DIR/install_qmidinet.sh
fi

# 2023-04-21: Update LV2, Lilv, etc. => PENDING OF TESTING!!!
#if is_python_module_installed.py meson; then
	#pip3 install meson ninja
	#$ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh
	#$ZYNTHIAN_RECIPE_DIR/install_lvtk.sh
	#$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv.sh
#fi

# 2023-06-26 Install python3-soundfile, rubberband, abletonparsing & pysox
res=`dpkg -s python3-soundfile 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs python3-soundfile rubberband-cli"
	pip3 install pyrubberband
	pip3 install abletonparsing
	pip3 install sox
fi

# 2023-06-28 Install librubberband-dev
res=`dpkg -s librubberband-dev 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	aptpkgs="$aptpkgs librubberband-dev"
fi

# 2023-06-30 Uninstall usbmount. Install udisks2 & udevil
res=`dpkg -s udisks2 2>&1 | grep "Status:"`
if [ "$res" != "Status: install ok installed" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y remove usbmount
	apt-get -y install udisks2 udevil
	systemctl enable devmon@root
	systemctl start devmon@root
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

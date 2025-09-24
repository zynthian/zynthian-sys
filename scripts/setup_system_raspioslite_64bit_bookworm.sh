#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup zynthian software stack in a fresh raspios-lite-64 "bullseye" image
# 
# Copyright (C) 2015-2023 Fernando Moyano <jofemodo@zynthian.org>
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
# 
#******************************************************************************

#------------------------------------------------------------------------------
# Set default password & enable ssh on first boot
#------------------------------------------------------------------------------

# With the SDcard mounted in your computer
cd /media/txino/bootfs
echo -n "zyn:" > userconf.txt
echo 'opensynth' | openssl passwd -6 -stdin >> userconf.txt
touch ssh

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "zynthian_envars_extended.sh"

#------------------------------------------------
# Set default config
#------------------------------------------------

[ -n "$ZYNTHIAN_INCLUDE_RPI_UPDATE" ] || ZYNTHIAN_INCLUDE_RPI_UPDATE=no
[ -n "$ZYNTHIAN_INCLUDE_PIP" ] || ZYNTHIAN_INCLUDE_PIP=yes
[ -n "$ZYNTHIAN_CHANGE_HOSTNAME" ] || ZYNTHIAN_CHANGE_HOSTNAME=yes

[ -n "$ZYNTHIAN_SYS_REPO" ] || ZYNTHIAN_SYS_REPO="https://github.com/zynthian/zynthian-sys.git"
[ -n "$ZYNTHIAN_UI_REPO" ] || ZYNTHIAN_UI_REPO="https://github.com/zynthian/zynthian-ui.git"
[ -n "$ZYNTHIAN_ZYNCODER_REPO" ] || ZYNTHIAN_ZYNCODER_REPO="https://github.com/zynthian/zyncoder.git"
[ -n "$ZYNTHIAN_WEBCONF_REPO" ] || ZYNTHIAN_WEBCONF_REPO="https://github.com/zynthian/zynthian-webconf.git"
[ -n "$ZYNTHIAN_DATA_REPO" ] || ZYNTHIAN_DATA_REPO="https://github.com/zynthian/zynthian-data.git"

[ -n "$ZYNTHIAN_BRANCH" ] || ZYNTHIAN_BRANCH="oram"
[ -n "$ZYNTHIAN_SYS_BRANCH" ] || ZYNTHIAN_SYS_BRANCH="oram"
[ -n "$ZYNTHIAN_UI_BRANCH" ] || ZYNTHIAN_UI_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_ZYNCODER_BRANCH" ] || ZYNTHIAN_ZYNCODER_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_WEBCONF_BRANCH" ] || ZYNTHIAN_WEBCONF_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_DATA_BRANCH" ] || ZYNTHIAN_DATA_BRANCH=$ZYNTHIAN_BRANCH

#------------------------------------------------
# Update System & Firmware
#------------------------------------------------

# Update System
apt-get -y update --allow-releaseinfo-change
apt-get -y full-upgrade

# Install required dependencies if needed
apt-get -y install apt-utils apt-transport-https rpi-update sudo software-properties-common parted dirmngr rpi-eeprom gpgv wget

# Update Firmware
if [ "$ZYNTHIAN_INCLUDE_RPI_UPDATE" == "yes" ]; then
    rpi-update
fi

#------------------------------------------------
# Add Repositories
#------------------------------------------------

# deb-multimedia repo
echo "deb https://www.deb-multimedia.org bookworm main non-free" >> /etc/apt/sources.list
apt-get -y update -oAcquire::AllowInsecureRepositories=true
apt-get -y --allow-unauthenticated  install deb-multimedia-keyring

# KXStudio
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_11.1.0_all.deb
sudo dpkg -i kxstudio-repos_11.1.0_all.deb
rm -f kxstudio-repos_11.1.0_all.deb

# Zynthian
wget -O - https://deb.zynthian.org/deb-zynthian-org.gpg > /etc/apt/trusted.gpg.d/deb-zynthian-org.gpg
echo "deb https://deb.zynthian.org/zynthian-oram bookworm-oram main" > "/etc/apt/sources.list.d/zynthian.list"

# Sfizz => Repo version segfaults!!
#sfizz_url_base="https://download.opensuse.org/repositories/home:/sfztools:/sfizz/Raspbian_12"
#echo "deb $sfizz_url_base/ /" | sudo tee /etc/apt/sources.list.d/home:sfztools:sfizz.list
#curl -fsSL $sfizz_url_base/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_sfztools_sfizz.gpg > /dev/null

apt-get -y update
apt-get -y full-upgrade
apt-get -y autoremove

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

# System
apt-get -y remove --purge isc-dhcp-client triggerhappy logrotate dphys-swapfile bluez
apt-get -y install systemd avahi-daemon dhcpcd-dbus usbutils udisks2 udevil exfatprogs \
xinit xserver-xorg-video-fbdev x11-xserver-utils xinput libgl1-mesa-dri tigervnc-standalone-server \
xfwm4 xfce4-panel xdotool cpufrequtils wpasupplicant wireless-tools iw dnsmasq \
firmware-brcm80211 firmware-atheros firmware-realtek atmel-firmware firmware-misc-nonfree \
shiki-colors-xfwm-theme fonts-freefont-ttf x11vnc xserver-xorg-input-evdev
#firmware-ralink 

#TODO => Configure xfwm to use shiki-colors theme in VNC

# CLI Tools
apt-get -y install psmisc tree joe nano vim p7zip-full i2c-tools ddcutil evtest libts-bin \
fbi scrot mpg123  mplayer xloadimage imagemagick fbcat abcmidi ffmpeg qjackctl mediainfo \
xterm gpiod xfce4-terminal tigervnc-tools
#  qmidinet

#------------------------------------------------
# Development Environment
#------------------------------------------------

# Libraries
# AV Libraries => WARNING It should be reviewed on every new debian version!!
apt-get -y --no-install-recommends install libx11-dev libx11-xcb-dev libxcb-util-dev libxkbcommon-dev \
libfftw3-dev libmxml-dev zlib1g-dev fluid libfltk1.3-dev libfltk1.3-compat-headers libpango1.0-dev \
libncurses5-dev liblo-dev dssi-dev libjpeg-dev libxpm-dev libcairo2-dev libglu1-mesa-dev \
libasound2-dev dbus-x11 jackd2 libjack-jackd2-dev a2jmidid jack-midi-clock midisport-firmware libffi-dev \
fontconfig-config libfontconfig1-dev libxft-dev libexpat-dev libglib2.0-dev libgettextpo-dev libsqlite3-dev \
libglibmm-2.4-dev libeigen3-dev libsamplerate-dev libarmadillo-dev libreadline-dev ttf-bitstream-vera \
lv2-c++-tools libxi-dev libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev libzita-convolver-dev \
libzita-resampler-dev fonts-roboto libxcursor-dev libxinerama-dev mesa-common-dev libgl1-mesa-dev \
libfreetype6-dev  libswscale-dev  qtbase5-dev qtdeclarative5-dev libcanberra-gtk-module '^libxcb.*-dev' \
libcanberra-gtk3-module libxcb-cursor-dev libgtk-3-dev libxcb-util0-dev libxcb-keysyms1-dev libxcb-xkb-dev \
libxkbcommon-x11-dev libssl-dev libmpg123-0 libmp3lame0 libqt5svg5-dev libxrender-dev librubberband-dev \
libavcodec59 libavformat59 libavutil57 libavformat-dev libavcodec-dev libgpiod-dev libganv-dev \
libsdl2-dev libibus-1.0-dev gir1.2-ibus-1.0 libdecor-0-dev libflac-dev libgbm-dev libibus-1.0-5 \
libmpg123-dev libvorbis-dev libogg-dev libopus-dev libpulse-dev libpulse-mainloop-glib0 libsndio-dev \
libsystemd-dev libudev-dev libxss-dev libxt-dev libxv-dev libxxf86vm-dev libglu-dev libftgl-dev libical-dev \
libclthreads-dev libclxclient-dev libwebkit2gtk-4.0-dev libboost-python-dev libboost-thread-dev libsndfile-zyndev

# Missed libs from previous OS versions:
# Removed from bookworm: libavresample4

# Tools
apt-get -y --no-install-recommends install build-essential git swig pkg-config autoconf automake premake \
subversion gettext intltool libtool libtool-bin cmake cmake-curses-gui flex bison ngrep qt5-qmake gobjc++ \
ruby rake xsltproc vorbis-tools zenity doxygen graphviz glslang-tools rubberband-cli docutils-common faust

# Missed tools from previous OS versions:
#libjack-dev-session
#non-ntk-dev
#libgd2-xpm-dev

# Python3
apt-get -y install python3 python3-dev python3-pip cython3 python3-cffi 2to3 python3-tk python3-dbus python3-mpmath \
python3-pil python3-pil.imagetk python3-setuptools python3-pyqt5 python3-numpy python3-evdev python3-usb \
python3-soundfile python3-psutil python3-pexpect python3-jsonpickle python3-requests python3-mido python3-rtmidi \
python3-mutagen python3-pam python3-bcrypt

# Python2 (DEPRECATED!!)
#apt-get -y install python-setuptools python-is-python2 python-dev-is-python2

#------------------------------------------------
# Create Zynthian Directory Tree 
# Install Zynthian Software from repositories
#------------------------------------------------

# Create needed directories
mkdir "$ZYNTHIAN_DIR"
mkdir "$ZYNTHIAN_CONFIG_DIR"
mkdir "$ZYNTHIAN_SW_DIR"

# Zynthian System Scripts and Config files
cd "$ZYNTHIAN_DIR"
git clone -b "${ZYNTHIAN_SYS_BRANCH}" "${ZYNTHIAN_SYS_REPO}"

# Config "git pull" strategy globally
# QUESTION: is this needed at all?
#git config --global pull.rebase false

# Zyncoder library
cd "$ZYNTHIAN_DIR"
git clone -b "${ZYNTHIAN_ZYNCODER_BRANCH}" "${ZYNTHIAN_ZYNCODER_REPO}"
./zyncoder/build.sh

# Zynthian UI
cd "$ZYNTHIAN_DIR"
git clone -b "${ZYNTHIAN_UI_BRANCH}" "${ZYNTHIAN_UI_REPO}"
cd "$ZYNTHIAN_UI_DIR"
find ./zynlibs -type f -name build.sh -exec {} \;

# Zynthian Data
cd "$ZYNTHIAN_DIR"
git clone -b "${ZYNTHIAN_DATA_BRANCH}" "${ZYNTHIAN_DATA_REPO}"

# Zynthian Webconf Tool
cd "$ZYNTHIAN_DIR"
git clone -b "${ZYNTHIAN_WEBCONF_BRANCH}" "${ZYNTHIAN_WEBCONF_REPO}"

# Create needed directories
#mkdir "$ZYNTHIAN_DATA_DIR/soundfonts"
#mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/lv2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/banks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/presets"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/puredata"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/puredata/generative"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/puredata/synths"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/sysex"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots/000"
mkdir "$ZYNTHIAN_MY_DATA_DIR/capture"
mkdir "$ZYNTHIAN_MY_DATA_DIR/preset-favorites"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/patterns"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/tracks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/sequences"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/scenes"
mkdir "$ZYNTHIAN_PLUGINS_DIR"
mkdir "$ZYNTHIAN_PLUGINS_DIR/lv2"

# Copy default snapshots
cp -a $ZYNTHIAN_DATA_DIR/snapshots/* $ZYNTHIAN_MY_DATA_DIR/snapshots/000

#------------------------------------------------
# Python Environment
#------------------------------------------------

cd "$ZYNTHIAN_DIR"
python3 -m venv venv --system-site-packages
source "$ZYNTHIAN_DIR/venv/bin/activate"

pip3 install --upgrade pip
pip3 install JACK-Client alsa-midi oyaml adafruit-circuitpython-neopixel-spi Levenshtein \
ffmpeg-python pyrubberband mididings sox meson ninja abletonparsing hwmon vcgencmd \
tornado tornadostreamform websocket-client tornado_xstatic terminado xstatic XStatic_term.js

#------------------------------------------------
# System Adjustments
#------------------------------------------------

# Use tmpfs for tmp & logs
echo "" >> /etc/fstab
echo "tmpfs  /tmp  tmpfs  defaults,noatime,nosuid,nodev,size=200M   0  0" >> /etc/fstab
echo "tmpfs  /var/tmp  tmpfs  defaults,noatime,nosuid,nodev,size=200M   0  0" >> /etc/fstab
echo "tmpfs  /var/log  tmpfs  defaults,noatime,nosuid,nodev,noexec,size=50M  0  0" >> /etc/fstab

# Fix timeout in network initialization
if [ ! -d "/etc/systemd/system/networking.service.d" ]; then
	mkdir -p "/etc/systemd/system/networking.service.d"
	echo -e "[Service]\nTimeoutStartSec=1\n" > "/etc/systemd/system/networking.service.d/reduce-timeout.conf"
fi

# Change Hostname
if [ "$ZYNTHIAN_CHANGE_HOSTNAME" == "yes" ]; then
    echo "zynthian" > /etc/hostname
    sed -i -e "s/127\.0\.1\.1.*$/127.0.1.1\tzynthian/" /etc/hosts
fi

# VNC password
if [ ! -d "/root/.vnc/" ]; then
	mkdir "/root/.vnc/"
fi
echo "opensynth" | vncpasswd -f > /root/.vnc/passwd
chmod go-r /root/.vnc/passwd

# Delete problematic file from X11 config (RPi3??)
if [ -f "/usr/share/X11/xorg.conf.d/20-noglamor.conf" ]; then
	rm -f /usr/share/X11/xorg.conf.d/20-noglamor.conf
fi

# Setup loading of Zynthian Environment variables ...
echo "source $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh > /dev/null 2>&1" >> /root/.bashrc

# => Shell & Login Config
echo "source $ZYNTHIAN_SYS_DIR/etc/profile.zynthian" >> /root/.profile
source $ZYNTHIAN_SYS_DIR/etc/profile.zynthian

# => Allow root ssh login
echo -e "\nPermitRootLogin yes" >> /etc/ssh/sshd_config

# ZynthianOS version
export ZYNTHIANOS_VERSION="2409"
echo $ZYNTHIANOS_VERSION > /etc/zynthianos_version
# Build Info
echo "ZynthianOS ORAM-$ZYNTHIANOS_VERSION" > $ZYNTHIAN_DIR/build_info.txt
echo "" >> $ZYNTHIAN_DIR/build_info.txt
echo "Timestamp: 2024-09-06"  >> $ZYNTHIAN_DIR/build_info.txt
echo "" >> $ZYNTHIAN_DIR/build_info.txt
echo "Built from RaspberryPiOS Bookworm ($MACHINE_HW_NAME)" >> $ZYNTHIAN_DIR/build_info.txt

# Run configuration script
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_data.sh
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh

# reboot ...

$ZYNTHIAN_SYS_DIR/sbin/zynthian_autoconfig.py

# Configure systemd services
systemctl daemon-reload
systemctl disable raspi-config
systemctl disable cron
systemctl disable dnsmasq
systemctl disable dhcpcd
systemctl disable apt-daily.timer
systemctl disable ModemManager
systemctl disable glamor-test.service
systemctl enable avahi-daemon
systemctl enable devmon@root
#systemctl disable wpa_supplicant
#systemctl disable hostapd
#systemctl disable rsyslog
#systemctl disable unattended-upgrades
#systemctl mask packagekit
#systemctl mask polkit
systemctl mask rpi-eeprom-update

# Zynthian specific systemd services
systemctl enable jack2
systemctl enable mod-ttymidi
systemctl enable a2jmidid
systemctl enable zynthian
systemctl enable zynthian-webconf
systemctl enable zynthian-config-on-boot

# On first boot, resize SD partition, regenerate keys, etc.
$ZYNTHIAN_SYS_DIR/scripts/set_first_boot.sh

#------------------------------------------------
# Build & Install Required Libraries
#------------------------------------------------

# Install Jack2
#$ZYNTHIAN_RECIPE_DIR/install_jack2.sh

# Install modified Bluez from zynthian repo
#$ZYNTHIAN_RECIPE_DIR/install_bluez.sh

# Install pyliblo library (liblo OSC library for Python)
$ZYNTHIAN_RECIPE_DIR/install_pyliblo.sh

# Install mod-ttymidi (MOD's ttymidi version with jackd MIDI support)
$ZYNTHIAN_RECIPE_DIR/install_mod-ttymidi.sh

# Install LV2 lilv library
$ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh

# Install the LV2 C++ Tool Kit
$ZYNTHIAN_RECIPE_DIR/install_lvtk.sh
# => lvtk-1 failed
# TODO FAILED=> ninja: build stopped: subcommand failed.

# Install LV2 Jalv Plugin Host
$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv.sh

# Install Aubio Library & Tools
$ZYNTHIAN_RECIPE_DIR/install_aubio.sh

# Install jpmidi (MID player for jack with transport sync)
#$ZYNTHIAN_RECIPE_DIR/install_jpmidi.sh
# TODO => No configure !! It must be changed to meson or waf or something like that....
# Do we need this? => I think no!!

# Install jack_capture (jackd audio recorder)
$ZYNTHIAN_RECIPE_DIR/install_jack_capture.sh

# Install jack_smf utils (jackd MID-file player/recorder)
$ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh

# Install touchosc2midi (TouchOSC Bridge)
$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh

# Install jackclient (jack-client python library)
#$ZYNTHIAN_RECIPE_DIR/install_jackclient-python.sh

# Install QMidiNet (MIDI over IP Multicast)
$ZYNTHIAN_RECIPE_DIR/install_qmidinet.sh

# Install jackrtpmidid (jack RTP-MIDI daemon)
$ZYNTHIAN_RECIPE_DIR/install_jackrtpmidid.sh

# Install the DX7 SysEx parser
$ZYNTHIAN_RECIPE_DIR/install_dxsyx.sh

# Install preset2lv2 (Convert native presets to LV2)
$ZYNTHIAN_RECIPE_DIR/install_preset2lv2.sh

# Install QJackCtl
#$ZYNTHIAN_RECIPE_DIR/install_qjackctl.sh

# Install patchage
$ZYNTHIAN_RECIPE_DIR/install_patchage.sh

# Install the njconnect Jack Graph Manager
$ZYNTHIAN_RECIPE_DIR/install_njconnect.sh

# Install Mutagen (when available, use pip3 install)
# $ZYNTHIAN_RECIPE_DIR/install_mutagen.sh

# Install VL53L0X library (Distance Sensor)
$ZYNTHIAN_RECIPE_DIR/install_VL53L0X.sh

# Install MCP4748 library (Analog Output / CV-OUT)
$ZYNTHIAN_RECIPE_DIR/install_MCP4728.sh

# Install noVNC web viewer
$ZYNTHIAN_RECIPE_DIR/install_noVNC.sh

# Install terminal emulator for tornado (webconf)
#$ZYNTHIAN_RECIPE_DIR/install_terminado.sh

# Install DT overlays for waveshare displays and others
$ZYNTHIAN_RECIPE_DIR/install_waveshare-dtoverlays.sh

# Install web filebrowser
$ZYNTHIAN_RECIPE_DIR/install_filebrowser.sh

#------------------------------------------------
# Build & Install Synthesis Software
#------------------------------------------------

# Install ZynAddSubFX => from Bookworm repository instead of KXStudio
#$ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
apt-get -y install -t bookworm zynaddsubfx
apt-get -y install -t bookworm zynaddsubfx-lv2
apt-mark hold zynaddsubfx
apt-mark hold zynaddsubfx-lv2

# Install Fluidsynth & SF2 SondFonts
apt-get -y remove libsndfile-zyndev
apt-get -y install libsndfile1-dev libinstpatch-dev
apt-get -y install fluidsynth libfluidsynth-dev fluid-soundfont-gm fluid-soundfont-gs timgm6mb-soundfont
# Stop & disable systemd fluidsynth service
systemctl stop --user fluidsynth.service
systemctl mask --user fluidsynth.service
# Create SF2 soft links
ln -s /usr/share/sounds/sf2/*.sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2

# Install Squishbox SF2 soundfonts
$ZYNTHIAN_RECIPE_DIR/install_squishbox_sf2.sh

# Install Polyphone (SF2 editor)
#$ZYNTHIAN_RECIPE_DIR/install_polyphone.sh

# Install Sfizz (SFZ player)
#apt-get -y install sfizz  # repo version segfaults!!!
$ZYNTHIAN_RECIPE_DIR/install_sfizz.sh

# Install Linuxsampler
#$ZYNTHIAN_RECIPE_DIR/install_linuxsampler_stable.sh
apt-get -y install linuxsampler gigtools

# Install Fantasia (linuxsampler Java GUI)
#$ZYNTHIAN_RECIPE_DIR/install_fantasia.sh

# Install setBfree (Hammond B3 Emulator)
$ZYNTHIAN_RECIPE_DIR/install_setbfree.sh
# Setup user config directories
cd $ZYNTHIAN_CONFIG_DIR
mkdir setbfree
ln -s /usr/local/share/setBfree/cfg/default.cfg ./setbfree
cp -a $ZYNTHIAN_DATA_DIR/setbfree/cfg/zynthian_my.cfg ./setbfree/zynthian.cfg

# Install Aeolus (Pipe Organ Emulator)
#apt-get -y install aeolus
$ZYNTHIAN_RECIPE_DIR/install_aeolus.sh

# Install Pianoteq Demo (Piano Physical Emulation)
$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh

# Install SooperLooper backend
apt-get -y install sooperlooper

# Install AIDA-X neural network loader
$ZYNTHIAN_RECIPE_DIR/install_aidax.sh

# Install Mididings (MIDI route & filter)
#apt-get -y install mididings
# TODO find a deb repo

# Install Pure Data stuff
apt-get -y install puredata puredata-core puredata-utils puredata-import python3-yaml \
pd-lua pd-moonlib pd-pdstring pd-markex pd-iemnet pd-plugin pd-ekext pd-bassemu pd-readanysf pd-pddp \
pd-zexy pd-list-abs pd-flite pd-windowing pd-fftease pd-bsaylor pd-osc pd-sigpack pd-hcs pd-pdogg pd-purepd \
pd-beatpipe pd-freeverb pd-iemlib pd-smlib pd-hid pd-csound pd-earplug pd-wiimote pd-pmpd pd-motex \
pd-arraysize pd-ggee pd-chaos pd-iemmatrix pd-comport pd-libdir pd-vbap pd-cxc pd-lyonpotpourri pd-iemambi \
pd-pdp pd-mjlib pd-cyclone pd-jmmmp pd-3dp pd-boids pd-mapping pd-maxlib
apt-get -y install pd-ambix pd-autopreset pd-cmos pd-creb pd-deken pd-deken-apt pd-extendedview pd-flext-dev pd-flext-doc pd-gil \
pd-hexloader pd-iem pd-jsusfx pd-kollabs pd-lib-builder pd-log pd-mediasettings pd-mrpeach-net pd-nusmuk pd-pan \
pd-pduino pd-pool pd-puremapping pd-purest-json pd-rtclib pd-slip pd-syslog pd-tclpd pd-testtools pd-unauthorized \
pd-upp pd-xbee pd-xsample

mkdir /root/Pd
mkdir /root/Pd/externals

#------------------------------------------------
# Install MOD stuff
#------------------------------------------------

# Install MOD-HOST
# Requires libjackd-jackd2-1.9.19 (JackTickDouble)
export MOD_HOST_GITSHA="0d1cb5484f5432cdf7fa297e0bfcc353d8a47e6b"
$ZYNTHIAN_RECIPE_DIR/install_mod-host.sh
 
# Install browsepy => Now it's installed with mod-ui
# $ZYNTHIAN_RECIPE_DIR/install_mod-browsepy.sh

#Install MOD-UI
$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh

#Install MOD-SDK
#$ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh

#------------------------------------------------
# Install Plugins
#------------------------------------------------
cd "$ZYNTHIAN_SYS_DIR/scripts"
./setup_plugins_rbpi.sh

#------------------------------------------------
# Install Ableton Link Support
#------------------------------------------------
$ZYNTHIAN_RECIPE_DIR/install_hylia.sh
$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh

#------------------------------------------------
# Zynthian specific packages (from zynthian repo)
#------------------------------------------------

apt-get -y remove libsndfile1-dev libfluidsynth-dev libinstpatch-dev
apt-get -y install libsndfile-zyndev zynbluez jamulus

#------------------------------------------------
# Final configuration
#------------------------------------------------

# Create flags to avoid running unneeded recipes.update when updating zynthian software
#if [ ! -d "$ZYNTHIAN_CONFIG_DIR/updates" ]; then
#	mkdir "$ZYNTHIAN_CONFIG_DIR/updates"
#fi

# Run configuration script before ending
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh

# Regenerate certificates
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Regenerate LV2 cache
cd $ZYNTHIAN_UI_DIR/zyngine
python3 ./zynthian_lv2.py

#------------------------------------------------
# End & Cleanup
#------------------------------------------------

#Block MS repo from being installed
#apt-mark hold raspberrypi-sys-mods
#touch /etc/apt/trusted.gpg.d/microsoft.gpg

# Clean
apt-get -y autoremove # Remove unneeded packages
if [[ "$ZYNTHIAN_SETUP_APT_CLEAN" == "yes" ]]; then # Clean apt cache (if instructed via zynthian_envars.sh)
    apt-get clean
fi

#------------------------------------------------



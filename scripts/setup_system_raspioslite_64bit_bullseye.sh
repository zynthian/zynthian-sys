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

[ -n "$ZYNTHIAN_BRANCH" ] || ZYNTHIAN_BRANCH="testing"
[ -n "$ZYNTHIAN_SYS_BRANCH" ] || ZYNTHIAN_SYS_BRANCH=$ZYNTHIAN_BRANCH
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
echo "deb https://www.deb-multimedia.org bullseye main non-free" >> /etc/apt/sources.list
apt-get -y update -oAcquire::AllowInsecureRepositories=true
apt-get -y --allow-unauthenticated  install deb-multimedia-keyring

# KXStudio
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_11.1.0_all.deb
sudo dpkg -i kxstudio-repos_11.1.0_all.deb
rm -f kxstudio-repos_11.1.0_all.deb

# Zynthian => TODO Add support for 64 bit!!!!
wget -O - https://deb.zynthian.org/deb-zynthian-org.gpg > /etc/apt/trusted.gpg.d/deb-zynthian-org.gpg
echo "deb https://deb.zynthian.org/zynthian-stable buster main" > /etc/apt/sources.list.d/zynthian.list

# Sfizz
#TODO Find a deb aarch64 repository!

apt-get -y update
apt-get -y full-upgrade
apt-get -y autoremove

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

# System
apt-get -y remove --purge isc-dhcp-client triggerhappy logrotate dphys-swapfile
apt-get -y install systemd avahi-daemon dhcpcd-dbus usbutils udisks2 udevil exfat-utils \
xinit xserver-xorg-video-fbdev x11-xserver-utils xinput libgl1-mesa-dri tigervnc-standalone-server \
xfwm4 xfce4-panel xdotool cpufrequtils wpasupplicant wireless-tools iw hostapd dnsmasq \
firmware-brcm80211 firmware-atheros firmware-realtek atmel-firmware firmware-misc-nonfree \
shiki-colors-xfwm-theme
#firmware-ralink

#TODO => Configure xfwm to use shiki-colors theme in VNC

# CLI Tools
apt-get -y install raspi-config psmisc tree joe nano vim p7zip-full i2c-tools ddcutil evtest libts-bin \
fbi scrot mpg123  mplayer xloadimage imagemagick fbcat abcmidi ffmpeg qjackctl mediainfo
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
libglibmm-2.4-dev libeigen3-dev libsndfile-dev libsamplerate-dev libarmadillo-dev libreadline-dev \
lv2-c++-tools libxi-dev libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev libzita-convolver-dev \
libzita-resampler-dev fonts-roboto libxcursor-dev libxinerama-dev mesa-common-dev libgl1-mesa-dev \
libfreetype6-dev  libswscale-dev  qtbase5-dev qtdeclarative5-dev libcanberra-gtk-module '^libxcb.*-dev' \
libcanberra-gtk3-module libxcb-cursor-dev libgtk-3-dev libxcb-util0-dev libxcb-keysyms1-dev libxcb-xkb-dev \
libxkbcommon-x11-dev libssl-dev libmpg123-0 libmp3lame0 libqt5svg5-dev libxrender-dev \
libavcodec58 libavformat58 libavutil56 libavresample4 libavformat-dev libavcodec-dev

# Tools
apt-get -y --no-install-recommends install build-essential git swig pkg-config autoconf automake premake \
subversion gettext intltool libtool libtool-bin cmake cmake-curses-gui flex bison ngrep qt5-qmake gobjc++ \
ruby rake xsltproc vorbis-tools zenity doxygen graphviz glslang-tools rubberband-cli

#libjack-dev-session
#non-ntk-dev
#libgd2-xpm-dev

# Python2 (DEPRECATED!!)
apt-get -y install python-is-python2 python-dev-is-python2 python-setuptools

# Python3
apt-get -y install python3 python3-dev python3-pip cython3 python3-cffi python3-tk python3-dbus python3-mpmath \
python3-pil python3-pil.imagetk python3-setuptools python3-pyqt5 python3-numpy python3-evdev 2to3  \
python3-soundfile librubberband-dev pyliblo-utils

pip3 install --upgrade pip
pip3 install tornado==4.5 tornadostreamform websocket-client jsonpickle oyaml JACK-Client sox \
psutil pexpect requests meson ninja mido python-rtmidi==1.4.9 rpi_ws281x ffmpeg-python pyrubberband mutagen \
abletonparsing

# NOTE:
# python-rtmidi >= 1.5 uses jack protocol 9, that is bumped in jackd 1.9.19

# TODO  install patchage or find a replacement

#************************************************
#------------------------------------------------
# Create Zynthian Directory Tree 
# Install Zynthian Software from repositories
#------------------------------------------------
#************************************************

# Create needed directories
mkdir "$ZYNTHIAN_DIR"
mkdir "$ZYNTHIAN_CONFIG_DIR"
mkdir "$ZYNTHIAN_SW_DIR"

# Zynthian System Scripts and Config files
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_SYS_BRANCH}" "${ZYNTHIAN_SYS_REPO}"

# Install WiringPi
$ZYNTHIAN_RECIPE_DIR/install_wiringpi.sh
#TODO Check this can't cause problems => pseudoPins.c:50:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

# Config "git pull" strategy globally
git config --global pull.rebase false

# Zyncoder library
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_ZYNCODER_BRANCH}" "${ZYNTHIAN_ZYNCODER_REPO}"
./zyncoder/build.sh

# Zynthian UI
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_UI_BRANCH}" "${ZYNTHIAN_UI_REPO}"
cd $ZYNTHIAN_UI_DIR
find ./zynlibs -type f -name build.sh -exec {} \;

# Zynthian Data
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_DATA_BRANCH}" "${ZYNTHIAN_DATA_REPO}"

# Zynthian Webconf Tool
cd $ZYNTHIAN_DIR
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

#************************************************
#------------------------------------------------
# System Adjustments
#------------------------------------------------
#************************************************

# Use tmpfs for tmp & logs
echo "" >> /etc/fstab
echo "tmpfs  /tmp  tmpfs  defaults,noatime,nosuid,nodev,size=20M   0  0" >> /etc/fstab
echo "tmpfs  /var/tmp  tmpfs  defaults,noatime,nosuid,nodev,size=5M   0  0" >> /etc/fstab
echo "tmpfs  /var/log  tmpfs  defaults,noatime,nosuid,nodev,noexec,size=20M  0  0" >> /etc/fstab

# Change Hostname
if [ "$ZYNTHIAN_CHANGE_HOSTNAME" == "yes" ]; then
    echo "zynthian" > /etc/hostname
    sed -i -e "s/127\.0\.1\.1.*$/127.0.1.1\tzynthian/" /etc/hosts
fi

# Run configuration script
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_data.sh

#$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh
$ZYNTHIAN_SYS_DIR/sbin/zynthian_autoconfig.sh

# Configure systemd services
systemctl daemon-reload
systemctl enable dhcpcd
systemctl enable avahi-daemon
systemctl disable raspi-config
systemctl disable cron
systemctl disable rsyslog
systemctl disable wpa_supplicant
systemctl disable hostapd
systemctl disable dnsmasq
systemctl disable unattended-upgrades
systemctl disable apt-daily.timer
#systemctl mask packagekit
#systemctl mask polkit
systemctl enable devmon@root

# Zynthian specific systemd services
systemctl enable backlight
systemctl enable cpu-performance
systemctl enable splash-screen
systemctl enable wifi-setup
systemctl enable jack2
systemctl enable mod-ttymidi
systemctl enable a2jmidid
systemctl enable zynthian
systemctl enable zynthian-webconf
systemctl enable zynthian-config-on-boot

# Setup loading of Zynthian Environment variables ...
echo "source $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh > /dev/null 2>&1" >> /root/.bashrc
# => Shell & Login Config
echo "source $ZYNTHIAN_SYS_DIR/etc/profile.zynthian" >> /root/.profile

# On first boot, resize SD partition, regenerate keys, etc.
$ZYNTHIAN_SYS_DIR/scripts/set_first_boot.sh


#************************************************
#------------------------------------------------
# Compile / Install Required Libraries
#------------------------------------------------
#************************************************

# Install Jack2
#$ZYNTHIAN_RECIPE_DIR/install_jack2.sh

# Install pyliblo library (liblo OSC library for Python)
#$ZYNTHIAN_RECIPE_DIR/install_pyliblo.sh

# Install mod-ttymidi (MOD's ttymidi version with jackd MIDI support)
$ZYNTHIAN_RECIPE_DIR/install_mod-ttymidi.sh

# Install LV2 lilv library
$ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh

# Install the LV2 C++ Tool Kit
$ZYNTHIAN_RECIPE_DIR/install_lvtk.sh

#TODO FAILED=> ninja: build stopped: subcommand failed.

# Install LV2 Jalv Plugin Host
$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv.sh

# Install Aubio Library & Tools
$ZYNTHIAN_RECIPE_DIR/install_aubio.sh

# Install jpmidi (MID player for jack with transport sync)
$ZYNTHIAN_RECIPE_DIR/install_jpmidi.sh

# Install jack_capture (jackd audio recorder)
$ZYNTHIAN_RECIPE_DIR/install_jack_capture.sh

# Install jack_smf utils (jackd MID-file player/recorder)
$ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh

# Install touchosc2midi (TouchOSC Bridge)
#$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh
#TODO FAILED=> build cython

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
$ZYNTHIAN_RECIPE_DIR/install_terminado.sh

# Install DT overlays for waveshare displays and others
$ZYNTHIAN_RECIPE_DIR/install_waveshare-dtoverlays.sh

#************************************************
#------------------------------------------------
# Compile / Install Synthesis Software
#------------------------------------------------
#************************************************

# Install ZynAddSubFX
#$ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
apt-get -y install zynaddsubfx

# Install Fluidsynth & SF2 SondFonts
apt-get -y install fluidsynth libfluidsynth-dev fluid-soundfont-gm fluid-soundfont-gs timgm6mb-soundfont
# Create SF2 soft links
ln -s /usr/share/sounds/sf2/*.sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2

# Install Squishbox SF2 soundfonts
$ZYNTHIAN_RECIPE_DIR/install_squishbox_sf2.sh

# Install Polyphone (SF2 editor)
#$ZYNTHIAN_RECIPE_DIR/install_polyphone.sh

# Install Sfizz (SFZ player)
$ZYNTHIAN_RECIPE_DIR/install_sfizz.sh
#apt-get -y install sfizz

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

# Install Pianoteq Demo (Piano Physical Emulation)
$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh

# Install Aeolus (Pipe Organ Emulator)
#apt-get -y install aeolus
$ZYNTHIAN_RECIPE_DIR/install_aeolus.sh

# Install Mididings (MIDI route & filter)
#apt-get -y install mididings
#TODO find a deb repo

# Install Pure Data stuff
apt-get -y install puredata puredata-core puredata-utils puredata-import python3-yaml \
pd-lua pd-moonlib pd-pdstring pd-markex pd-iemnet pd-plugin pd-ekext pd-bassemu pd-readanysf pd-pddp \
pd-zexy pd-list-abs pd-flite pd-windowing pd-fftease pd-bsaylor pd-osc pd-sigpack pd-hcs pd-pdogg pd-purepd \
pd-beatpipe pd-freeverb pd-iemlib pd-smlib pd-hid pd-csound pd-earplug pd-wiimote pd-pmpd pd-motex \
pd-arraysize pd-ggee pd-chaos pd-iemmatrix pd-comport pd-libdir pd-vbap pd-cxc pd-lyonpotpourri pd-iemambi \
pd-pdp pd-mjlib pd-cyclone pd-jmmmp pd-3dp pd-boids pd-mapping pd-maxlib

mkdir /root/Pd
mkdir /root/Pd/externals

#------------------------------------------------
# Install MOD stuff
#------------------------------------------------

# Install MOD-HOST
# Requires libjackd-jackd2-1.9.19 (JackTickDouble), bullseye has 1.9.17
export MOD_HOST_GITSHA="0d1cb5484f5432cdf7fa297e0bfcc353d8a47e6b"
$ZYNTHIAN_RECIPE_DIR/install_mod-host.sh
 
# Install browsepy
$ZYNTHIAN_RECIPE_DIR/install_mod-browsepy.sh

#Install MOD-UI
$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
#TODO FAILED to install pycrypto (pip3) => It's obsolete!

#Install MOD-SDK
#$ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh

#------------------------------------------------
# Install Plugins
#------------------------------------------------
cd $ZYNTHIAN_SYS_DIR/scripts
./setup_plugins_rbpi.sh
#TODO Review this => surge binary from repo fails?? => Install our own binary.

#------------------------------------------------
# Install Ableton Link Support
#------------------------------------------------
$ZYNTHIAN_RECIPE_DIR/install_hylia.sh
$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh

#************************************************
#------------------------------------------------
# Final Configuration
#------------------------------------------------
#************************************************

# Create flags to avoid running unneeded recipes.update when updating zynthian software
if [ ! -d "$ZYNTHIAN_CONFIG_DIR/updates" ]; then
	mkdir "$ZYNTHIAN_CONFIG_DIR/updates"
fi

# Run configuration script before ending
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh

# Regenerate certificates
$ZYNTHIAN_SYS_DIR/sbin/regenerate_keys.sh

# Regenerate LV2 cache
cd $ZYNTHIAN_UI_DIR/zyngine
python3 ./zynthian_lv2.py


#************************************************
#------------------------------------------------
# End & Clean
#------------------------------------------------
#************************************************

#Block MS repo from being installed
#apt-mark hold raspberrypi-sys-mods
touch /etc/apt/trusted.gpg.d/microsoft.gpg

# Clean
apt-get -y autoremove # Remove unneeded packages
if [[ "$ZYNTHIAN_SETUP_APT_CLEAN" == "yes" ]]; then # Clean apt cache (if instructed via zynthian_envars.sh)
    apt-get clean
fi

#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup a Zynthian Box in a fresh minibian-jessie installation
# 
# Copyright (C) 2015-2016 Fernando Moyano <jofemodo@zynthian.org>
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

source zynthian_envars.sh

#------------------------------------------------
# Update System & Firmware
#------------------------------------------------

# Update System
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

# Install required dependencies if needed
apt-get -y install apt-utils
apt-get -y install sudo apt-transport-https software-properties-common rpi-update htpdate parted

# Adjust System Date/Time
htpdate 0.europe.pool.ntp.org

# Update Firmware
rpi-update

#------------------------------------------------
# Add Repositories
#------------------------------------------------

# deb-multimedia repo
echo "deb http://www.deb-multimedia.org jessie main" >> /etc/apt/sources.list
apt-get -y --force-yes install deb-multimedia-keyring
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117

# Autostatic Repo
wget -O - http://rpi.autostatic.com/autostatic.gpg.key| apt-key add -
wget -O /etc/apt/sources.list.d/autostatic-audio-raspbian.list http://rpi.autostatic.com/autostatic-audio-raspbian.list

apt-get update
#apt-get -y dist-upgrade

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

# System
apt-get -y install systemd dhcpcd-dbus avahi-daemon usbmount
apt-get -y install xinit xserver-xorg-video-fbdev x11-xserver-utils xinput
apt-get -y install wpasupplicant firmware-brcm80211 wireless-tools
apt-get -y remove isc-dhcp-client
apt-get -y remove libgl1-mesa-dri

# CLI Tools
apt-get -y install raspi-config psmisc tree joe nano
apt-get -y install fbi scrot mpg123 p7zip-full i2c-tools
apt-get -y install evtest tslib libts-bin # touchscreen tools
#apt-get install python-smbus (i2c with python)

#------------------------------------------------
# Development Environment
#------------------------------------------------

#Tools
apt-get -y install build-essential git swig subversion pkg-config autoconf automake premake gettext intltool libtool libtool-bin cmake cmake-curses-gui flex bison ngrep

# Libraries
apt-get -y --force-yes install wiringpi libfftw3-dev libmxml-dev zlib1g-dev libfltk1.3-dev libncurses5-dev \
liblo-dev dssi-dev libjpeg-dev libxpm-dev libcairo2-dev libglu1-mesa-dev \
libasound2-dev dbus-x11 jackd2 libjack-jackd2-dev a2jmidid laditools \
liblash-compat-dev libffi-dev fontconfig-config libfontconfig1-dev libxft-dev \
libexpat-dev libglib2.0-dev libgettextpo-dev libglibmm-2.4-dev libeigen3-dev \
libsndfile-dev libsamplerate-dev libarmadillo-dev libreadline-dev lv2-c++-tools python3-numpy-dev \
libavcodec56 libavformat56 libavutil54 libavresample2 python3-pyqt4 libxi-dev libsqlite3-dev \
libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev libzita-convolver-dev libzita-resampler-dev \
fonts-roboto

#libjack-dev-session
#non-ntk-dev
#libgd2-xpm-dev

# Python
apt-get -y install python python-dev python-pip cython python-dbus 
apt-get -y install python3 python3-dev python3-pip cython3 python3-cffi python3-tk python3-dbus python3-mpmath python3-pil python3-pil.imagetk
pip3 install websocket-client
pip3 install tornado==4.1
pip3 install tornadostreamform
pip3 install jsonpickle

# Clean
apt-get -y autoremove # Remove unneeded packages
if [[ "$ZYNTHAIN_SETUP_APT_CLEAN" = "TRUE" ]]; then # Clean apt cache (if instructed via zynthian_envars.sh)
   apt-get clean
fi

#************************************************
#------------------------------------------------
# Create Zynthian Directory Tree & 
# Install Zynthian Software from repositories
#------------------------------------------------
#************************************************
mkdir $ZYNTHIAN_DIR
mkdir $ZYNTHIAN_CONFIG_DIR

# Zyncoder library 
cd $ZYNTHIAN_DIR
git clone https://github.com/zynthian/zyncoder.git
mkdir zyncoder/build
cd zyncoder/build
cmake ..
make

# Zynthian UI
cd $ZYNTHIAN_DIR
git clone https://github.com/zynthian/zynthian-ui.git

# Zynthian System Scripts and Config files
cd $ZYNTHIAN_DIR
git clone https://github.com/zynthian/zynthian-sys.git

# Zynthian Data
cd $ZYNTHIAN_DIR
git clone https://github.com/zynthian/zynthian-data.git

# Zynthian Webconf Tool
cd $ZYNTHIAN_DIR
git clone https://github.com/zynthian/zynthian-webconf.git

# Zynthian Plugins => TODO! => Rethink plugins directory!!
#git clone https://github.com/zynthian/zynthian-plugins.git

# Zynthian emuface => Not very useful here ... but somebody used it
git clone https://github.com/zynthian/zynthian-emuface.git

# Create needed directories
mkdir $ZYNTHIAN_SW_DIR
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/gig"
mkdir $ZYNTHIAN_MY_DATA_DIR
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/xiz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/xmz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/xsz"
ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/xiz" "$ZYNTHIAN_MY_DATA_DIR/zynbanks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots"
mkdir "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards"
mkdir "$ZYNTHIAN_MY_DATA_DIR/capture"
mkdir $ZYNTHIAN_PLUGINS_DIR
mkdir "$ZYNTHIAN_PLUGINS_DIR/lv2"
mkdir $ZYNTHIAN_MY_PLUGINS_DIR
mkdir "$ZYNTHIAN_MY_PLUGINS_DIR/lv2"

# Copy some files
cp -a $ZYNTHIAN_DATA_DIR/mod-pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards

#************************************************
#------------------------------------------------
# System Adjustments
#------------------------------------------------
#************************************************

# Change Hostname
echo "zynthian" > /etc/hostname
sed -i -e "s/minibian/zynthian/" /etc/hosts

# Run configuration script
bash $ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh

# Systemd Services
systemctl daemon-reload
systemctl enable dhcpcd
systemctl enable wpa_supplicant
systemctl enable avahi-daemon
systemctl disable raspi-config
systemctl disable cron
systemctl disable rsyslog
systemctl disable ntp
systemctl disable triggerhappy
#systemctl disable serial-getty@ttyAMA0.service
#systemctl disable sys-devices-platform-soc-3f201000.uart-tty-ttyAMA0.device
systemctl enable backlight
systemctl enable cpu-performance
systemctl enable splash-screen
systemctl enable jack2
systemctl enable mod-ttymidi
systemctl enable zynthian
systemctl enable zynthian-webconf

# Setup loading of Zynthian Environment variables ...
echo "source $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" >> /root/.bashrc
# => Shell & Login Config
echo "source $ZYNTHIAN_SYS_DIR/etc/profile.zynthian" >> /root/.profile

# Resize SD partition on first boot
sed -i -- "s/exit 0/\/zynthian\/zynthian-sys\/scripts\/rpi-wiggle\.sh/" /etc/rc.local
echo "exit 0" >> /etc/rc.local

#************************************************
#------------------------------------------------
# Compile / Install Required Libraries
#------------------------------------------------
#************************************************

# Install alsaseq Python Library
bash $ZYNTHIAN_RECIPE_DIR/install_alsaseq.sh

# Install NTK library
bash $ZYNTHIAN_RECIPE_DIR/install_ntk.sh

# Install pyliblo library (liblo OSC library for Python)
bash $ZYNTHIAN_RECIPE_DIR/install_pyliblo.sh

# Install mod-ttymidi (MOD's ttymidi version with jackd MIDI support)
bash $ZYNTHIAN_RECIPE_DIR/install_mod-ttymidi.sh

# Install LV2 lilv library
bash $ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh # throws an error at the end - ignore it!

# Install Aubio Library & Tools
bash $ZYNTHIAN_RECIPE_DIR/install_aubio.sh

# Install jpmidi (MID player for jack with transport sync)
bash $ZYNTHIAN_RECIPE_DIR/install_jpmidi.sh

# Install jack_capture (jackd audio recorder)
bash $ZYNTHIAN_RECIPE_DIR/install_jack_capture.sh

# Install jack_smf utils (jackd MID-file player/recorder)
bash $ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh

# Install touchosc2midi (TouchOSC Bridge)
bash $ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh

# Install jackclient (jack-client python library)
bash $ZYNTHIAN_RECIPE_DIR/install_jackclient-python.sh


#************************************************
#------------------------------------------------
# Compile / Install Synthesis Software
#------------------------------------------------
#************************************************

# Install ZynAddSubFX
bash $ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh

# Install Fluidsynth & SF2 SondFonts
apt-get -y install fluidsynth fluid-soundfont-gm fluid-soundfont-gs
# Create SF2 soft links
ln -s /usr/share/sounds/sf2/*.sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2

# Install Polyphone (SF2 editor)
#bash $ZYNTHIAN_RECIPE_DIR/install_polyphone.sh

# Install Linuxsampler 2.0
bash $ZYNTHIAN_RECIPE_DIR/install_linuxsampler.sh

# Install Fantasia (linuxsampler Java GUI)
bash $ZYNTHIAN_RECIPE_DIR/install_fantasia.sh

# Install setBfree (Hammond B3 Emulator)
bash $ZYNTHIAN_RECIPE_DIR/install_setbfree.sh

# Install MOD stuff
cd $ZYNTHIAN_SYS_DIR/scripts
./setup_mod.sh

# Install Plugins
cd $ZYNTHIAN_SYS_DIR/scripts
./setup_plugins_rbpi.sh


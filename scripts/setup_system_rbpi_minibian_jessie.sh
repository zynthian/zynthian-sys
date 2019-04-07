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

export DEBIAN_FRONTEND=noninteractive

#------------------------------------------------
# Update System & Firmware
#------------------------------------------------

# Update System
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

# Install required dependencies if needed
apt-get -y install apt-utils
apt-get -y install sudo apt-transport-https software-properties-common rpi-update htpdate parted dirmngr

if [ "$ZYNTHIAN_INCLUDE_RPI_UPDATE" == "yes" ]; then
    apt-get -y install rpi-update
fi

# Adjust System Date/Time
htpdate -s www.pool.ntp.org www.ntp.br www.wikipedia.org 0.europe.pool.ntp.org www.google.co.uk

# Update Firmware
if [ "$ZYNTHIAN_INCLUDE_RPI_UPDATE" == "yes" ]; then
    rpi-update
fi

#------------------------------------------------
# Add Repositories
#------------------------------------------------

# deb-multimedia repo
echo "deb http://www.deb-multimedia.org jessie main" >> /etc/apt/sources.list
apt-get -y --force-yes install deb-multimedia-keyring
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117

apt-get update
#apt-get -y dist-upgrade

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

# System
apt-get -y remove isc-dhcp-client
apt-get -y install systemd dhcpcd-dbus avahi-daemon usbmount usbutils
apt-get -y install xinit xserver-xorg-video-fbdev x11-xserver-utils xinput libgl1-mesa-swx11 libgl1-mesa-dri
apt-get -y install wpasupplicant firmware-brcm80211 firmware-atheros firmware-ralink firmware-realtek atmel-firmware wireless-tools

# CLI Tools
apt-get -y install raspi-config psmisc tree joe nano vim
apt-get -y install fbi scrot mpg123 p7zip-full i2c-tools mplayer xloadimage imagemagick
apt-get -y install evtest tslib libts-bin # touchscreen tools
#apt-get install python-smbus (i2c with python)

# Non-free WIFI firmware for RBPi3
wget https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/firmware-brcm80211_20161130-3+rpt3_all.deb
dpkg -i firmware-brcm80211_20161130-3+rpt3_all.deb
rm -f firmware-brcm80211_20161130-3+rpt3_all.deb

#------------------------------------------------
# Development Environment
#------------------------------------------------

#Tools
apt-get -y install build-essential git swig subversion pkg-config autoconf automake premake gettext intltool libtool libtool-bin cmake cmake-curses-gui flex bison ngrep qt5-qmake qt4-qmake qt5-default gobjc++ ruby rake xsltproc

# Libraries
apt-get -y --force-yes --no-install-recommends install wiringpi libfftw3-dev libmxml-dev zlib1g-dev \
libfltk1.3-dev libncurses5-dev liblo-dev dssi-dev libjpeg-dev libxpm-dev libcairo2-dev libglu1-mesa-dev \
libasound2-dev dbus-x11 jackd2 libjack-jackd2-dev a2jmidid laditools liblash-compat-dev libffi-dev \
fontconfig-config libfontconfig1-dev libxft-dev libexpat-dev libglib2.0-dev libgettextpo-dev libsqlite3-dev \
libglibmm-2.4-dev libeigen3-dev libsndfile-dev libsamplerate-dev libarmadillo-dev libreadline-dev \
lv2-c++-tools libavcodec56 libavformat56 libavutil54 libavresample2 libxi-dev libgtk2.0-dev \
libgtkmm-2.4-dev liblrdf-dev libboost-system-dev libzita-convolver-dev libzita-resampler-dev \
fonts-roboto libxcursor-dev libxinerama-dev libcurl4-openssl-dev mesa-common-dev libgl1-mesa-dev libfreetype6-dev \
libavformat-dev libswscale-dev libavcodec-dev libqt5-dev libqt4-dev

#libjack-dev-session
#non-ntk-dev
#libgd2-xpm-dev

# Python
apt-get -y install python python-dev python-pip cython python-dbus python-setuptools
apt-get -y install python3 python3-dev python3-pip cython3 python3-cffi python3-tk python3-dbus python3-mpmath python3-pil python3-pil.imagetk python3-setuptools python3-pyqt4 python3-numpy-dev

pip3 install tornado==4.1 tornadostreamform websocket-client
pip3 install jsonpickle oyaml psutil pexpect requests
pip3 install mido python-rtmidi


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
mkdir "$ZYNTHIAN_CONFIG_DIR"
mkdir "$ZYNTHIAN_SW_DIR"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/XMZ"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/XSZ"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/XLZ"
ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx" "$ZYNTHIAN_MY_DATA_DIR/zynbanks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots"
mkdir "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards"
mkdir "$ZYNTHIAN_MY_DATA_DIR/capture"
mkdir "$ZYNTHIAN_PLUGINS_DIR"
mkdir "$ZYNTHIAN_PLUGINS_DIR/lv2"
mkdir "$ZYNTHIAN_MY_PLUGINS_DIR"
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
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_data.sh
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh

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
systemctl enable a2jmidid
systemctl enable zynthian
systemctl enable zynthian-webconf

# Setup loading of Zynthian Environment variables ...
echo "source $ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" >> /root/.bashrc
# => Shell & Login Config
echo "source $ZYNTHIAN_SYS_DIR/etc/profile.zynthian" >> /root/.profile

# On first boot, resize SD partition, regenerate keys, etc.
$ZYNTHIAN_SYS_DIR/scripts/set_first_boot.sh


#************************************************
#------------------------------------------------
# Compile / Install Required Libraries
#------------------------------------------------
#************************************************

# Install alsaseq Python Library
$ZYNTHIAN_RECIPE_DIR/install_alsaseq.sh

# Install NTK library
$ZYNTHIAN_RECIPE_DIR/install_ntk.sh

# Install pyliblo library (liblo OSC library for Python)
$ZYNTHIAN_RECIPE_DIR/install_pyliblo.sh

# Install mod-ttymidi (MOD's ttymidi version with jackd MIDI support)
$ZYNTHIAN_RECIPE_DIR/install_mod-ttymidi.sh

# Install LV2 lilv library
$ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh # throws an error at the end - ignore it!

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
$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh

# Install jackclient (jack-client python library)
$ZYNTHIAN_RECIPE_DIR/install_jackclient-python.sh

# Install QMidiNet (MIDI over IP Multicast)
$ZYNTHIAN_RECIPE_DIR/install_qmidinet.sh

#************************************************
#------------------------------------------------
# Compile / Install Synthesis Software
#------------------------------------------------
#************************************************

# Install ZynAddSubFX
$ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh

# Install Fluidsynth & SF2 SondFonts
apt-get -y install fluidsynth libfluidsynth-dev fluid-soundfont-gm fluid-soundfont-gs
# Create SF2 soft links
ln -s /usr/share/sounds/sf2/*.sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2

# Install Polyphone (SF2 editor)
#$ZYNTHIAN_RECIPE_DIR/install_polyphone.sh

# Install Linuxsampler 2.0
$ZYNTHIAN_RECIPE_DIR/install_linuxsampler_stable.sh

# Install Fantasia (linuxsampler Java GUI)
$ZYNTHIAN_RECIPE_DIR/install_fantasia.sh

# Install setBfree (Hammond B3 Emulator)
$ZYNTHIAN_RECIPE_DIR/install_setbfree.sh

# Install Pianoteq Demo (Piano Physical Emulation)
$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh

# Install Aeolus (Pipe Organ Emulator)
apt-get -y install aeolus mididings

# Install Pure Data stuff
apt-get -y install puredata puredata-core puredata-utils python3-yaml \
pd-lua pd-moonlib pd-pdstring pd-markex pd-iemnet pd-plugin pd-ekext pd-import pd-bassemu pd-readanysf pd-pddp \
pd-zexy pd-list-abs pd-flite pd-windowing pd-fftease pd-bsaylor pd-osc pd-sigpack pd-hcs pd-pdogg pd-purepd \
pd-beatpipe pd-freeverb pd-iemlib pd-smlib pd-hid pd-csound pd-aubio pd-earplug pd-wiimote pd-pmpd pd-motex \
pd-arraysize pd-ggee pd-chaos pd-iemmatrix pd-comport pd-libdir pd-vbap pd-cxc pd-lyonpotpourri pd-iemambi \
pd-pdp pd-mjlib pd-cyclone pd-jmmmp pd-3dp pd-boids pd-mapping pd-maxlib

#------------------------------------------------
# Install MOD stuff
#------------------------------------------------

#Define git version to use: Git commit SHAs where the local zynthian branch will be created
#export MOD_HOST_GITSHA="3bda867acf68b95c05baa7366d89687cbd9e47cf"
#export MOD_UI_GITSHA="064c64a24989120731157ac27184d4b4f51ef9f2"

#Install MOD-HOST
$ZYNTHIAN_RECIPE_DIR/install_mod-host.sh

#Install MOD-UI
$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
$ZYNTHIAN_RECIPE_DIR/install_phantomjs.sh

#Install MOD-SDK
$ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh

#Create softlink to pedalboards directory
ln -s $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards /root/.pedalboards

#------------------------------------------------
# Install Plugins
#------------------------------------------------
cd $ZYNTHIAN_SYS_DIR/scripts
./setup_plugins_rbpi.sh

#------------------------------------------------
# Install Ableton Link Support
#------------------------------------------------
$ZYNTHIAN_RECIPE_DIR/install_hylia.sh
$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh

#------------------------------------------------
# Install AminoGFX for Node.js graphics rendering
#------------------------------------------------
#$ZYNTHIAN_RECIPE_DIR/install_aminogfx.sh

#************************************************
#------------------------------------------------
# End & Clean
#------------------------------------------------
#************************************************

# Create flags to avoid running unneeded recipes.update when updating zynthian software
if [ ! -d "$ZYNTHIAN_CONFIG_DIR/updates" ]; then
	mkdir "$ZYNTHIAN_CONFIG_DIR/updates"
fi
touch "$ZYNTHIAN_CONFIG_DIR/updates/omega"

# Clean
apt-get -y autoremove # Remove unneeded packages
if [[ "$ZYNTHAIN_SETUP_APT_CLEAN" = "TRUE" ]]; then # Clean apt cache (if instructed via zynthian_envars.sh)
   apt-get clean
fi

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
# Update System
#------------------------------------------------

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y install rpi-update
rpi-update

#------------------------------------------------
# Add Repositories
#------------------------------------------------

# Install required dependencies if needed
apt-get -y install apt-transport-https software-properties-common wget

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
apt-get -y install sudo apt-utils ntpdate parted
apt-get -y install systemd dhcpcd-dbus avahi-daemon
apt-get -y install xinit xserver-xorg-video-fbdev x11-xserver-utils
apt-get -y remove isc-dhcp-client
apt-get -y remove libgl1-mesa-dri

# CLI Tools
apt-get -y install raspi-config psmisc tree joe 
apt-get -y install fbi scrot mpg123 p7zip-full i2c-tools
apt-get -y install evtest tslib libts-bin # touchscreen tools
#apt-get install python-smbus (i2c with python)

#------------------------------------------------
# Development Environment
#------------------------------------------------

#Tools
apt-get -y install build-essential git swig subversion autoconf automake premake gettext intltool libtool libtool-bin cmake cmake-curses-gui

# Libraries
apt-get -y --force-yes install wiringpi libfftw3-dev libmxml-dev zlib1g-dev libfltk1.3-dev libncurses5-dev \
liblo-dev dssi-dev libjpeg-dev libxpm-dev libcairo2-dev libglu1-mesa-dev \
libasound2-dev dbus-x11 jackd2 libjack-jackd2-dev a2jmidid laditools \
liblash-compat-dev libffi-dev fontconfig-config libfontconfig1-dev libxft-dev \
libexpat-dev libglib2.0-dev libgettextpo-dev libglibmm-2.4-dev libeigen3-dev \
libsndfile-dev libsamplerate-dev libarmadillo-dev libreadline-dev lv2-c++-tools python3-numpy-dev \
libavcodec56 libavformat56 libavutil54 libavresample2
#libjack-dev-session
#non-ntk-dev
#libgd2-xpm-dev

# Python
apt-get -y install python-dbus
apt-get -y install python3 python3-dev python3-pip cython3 python3-cffi python3-tk python3-dbus python3-mpmath
pip3 install websocket-client
pip3 install JACK-Client

#************************************************
#------------------------------------------------
# Create Zynthian Directory Tree & 
# Install Zynthian Software from repositories
#------------------------------------------------
#************************************************
mkdir $ZYNTHIAN_DIR
cd $ZYNTHIAN_DIR

# Zyncoder library
git clone https://github.com/zynthian/zyncoder.git
mkdir zyncoder/build
cd zyncoder/build
cmake ..
make

# Zynthian UI
cd $ZYNTHIAN_DIR
git clone -b $ZYNTHIAN_BRANCH --single-branch https://github.com/zynthian/zynthian-ui.git
# Exclude configuration file from git commands
cd zynthian-ui
git update-index --assume-unchanged zynthian_gui_config.py

# Zynthian System Scripts and Config files
cd $ZYNTHIAN_DIR
git clone -b $ZYNTHIAN_BRANCH --single-branch https://github.com/zynthian/zynthian-sys.git

# Zynthian Data
cd $ZYNTHIAN_DIR
git clone https://github.com/zynthian/zynthian-data.git

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
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynbanks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots"
mkdir "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards"
mkdir $ZYNTHIAN_PLUGINS_DIR
mkdir "$ZYNTHIAN_PLUGINS_DIR/lv2"
mkdir $ZYNTHIAN_MY_PLUGINS_DIR
mkdir "$ZYNTHIAN_MY_PLUGINS_DIR/lv2"

# Copy some files
cp -a $ZYNTHIAN_DATA_DIR/mod-pedalboards/* $ZYNTHIAN_MY_DATA_DIR/mod-pedalboards
rm -f "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards/*.txt"

#************************************************
#------------------------------------------------
# System Adjustments
#------------------------------------------------
#************************************************

#Change Hostname
echo "zynthian" > /etc/hostname

# Copy "boot" config files
cp $ZYNTHIAN_SYS_DIR/boot/* /boot
sed -i -e "s/#AUDIO_DEVICE_DTOVERLAY/dtoverlay=hifiberry-dacplus/g" /boot/config.txt

# Copy "etc" config files
cp $ZYNTHIAN_SYS_DIR/etc/modules /etc
cp $ZYNTHIAN_SYS_DIR/etc/inittab /etc
cp $ZYNTHIAN_SYS_DIR/etc/dbus-1/* /etc/dbus-1
cp $ZYNTHIAN_SYS_DIR/etc/systemd/* /etc/systemd/system
cp $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# Systemd Services
systemctl daemon-reload
systemctl enable dhcpcd
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

# X11 Config
mkdir /etc/X11/xorg.conf.d
cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# Copy fonts to system directory
cp -rf $ZYNTHIAN_UI_DIR/fonts/* /usr/share/fonts/truetype

# User Config (root) =>
# Set Zynthian Environment variables ...
echo "source /zynthian/zynthian-sys/scripts/zynthian_envars.sh" >> /root/.bashrc
# => Shell & Login Config
cp $ZYNTHIAN_SYS_DIR/etc/profile.zynthian /root/.profile.zynthian
echo "source .profile.zynthian" >> /root/.profile
# => ZynAddSubFX Config
cp $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

#************************************************
#------------------------------------------------
# Compile / Install Other Required Libraries
#------------------------------------------------
#************************************************

ntpdate 0.europe.pool.ntp.org

#------------------------------------------------
# Install Alsaseq Python Library
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
wget http://pp.com.mx/python/alsaseq/alsaseq-0.4.1.tar.gz
tar xfvz alsaseq-0.4.1.tar.gz
cd alsaseq-0.4.1
python3 setup.py install
rm -f alsaseq-0.4.1.tar.gz

#------------------------------------------------
# Install NTK
#------------------------------------------------
git clone git://git.tuxfamily.org/gitroot/non/fltk.git ntk
cd ntk
./waf configure
./waf
./waf install

#------------------------------------------------
# Install pyliblo (liblo OSC library for Python)
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/dsacre/pyliblo.git
cd pyliblo
python3 ./setup.py build
python3 ./setup.py install

#------------------------------------------------
# Install mod-ttymidi (MOD's version!)
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/moddevices/mod-ttymidi.git
cd mod-ttymidi
make install

#------------------------------------------------
# Install LV2 lilv library
#------------------------------------------------
sh $ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh # throws an error at the end - ignore it!

#------------------------------------------------
# Install Aubio Library & Tools
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/aubio/aubio.git
cd aubio
make -j 4
cp -fa ./build/src/libaubio* /usr/local/lib
cp -fa ./build/examples/aubiomfcc /usr/local/bin
cp -fa ./build/examples/aubionotes /usr/local/bin
cp -fa ./build/examples/aubioonset /usr/local/bin
cp -fa ./build/examples/aubiopitch /usr/local/bin
cp -fa ./build/examples/aubioquiet /usr/local/bin
cp -fa ./build/examples/aubiotrack /usr/local/bin

#************************************************
#------------------------------------------------
# Compile / Install Synthesis Software
#------------------------------------------------
#************************************************

#------------------------------------------------
# Install zynaddsubfx
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/fundamental/zynaddsubfx.git
cd zynaddsubfx
mkdir build
cd build
cmake ..
#ccmake .
# => delete "-msse -msse2 -mfpmath=sse" 
# => optimizations: -pipe -mfloat-abi=hard -mfpu=neon-vfpv4 -mvectorize-with-neon-quad -funsafe-loop-optimizations -funsafe-math-optimizations
# => optimizations that doesn't work: -mcpu=cortex-a7 -mtune=cortex-a7
sed -i -- 's/-march=armv7-a -mfloat-abi=hard -mfpu=neon -mcpu=cortex-a9 -mtune=cortex-a9 -pipe -mvectorize-with-neon-quad -funsafe-loop-optimizations/-pipe -mfloat-abi=hard -mfpu=neon-vfpv4 -mvectorize-with-neon-quad -funsafe-loop-optimizations -funsafe-math-optimizations/' CMakeCache.txt
make -j 4
make install

#Create soft link to zynbanks
ln -s $ZYNTHIAN_SW_DIR/zynaddsubfx/instruments/banks $ZYNTHIAN_DATA_DIR/zynbanks

#Create soft links to LV2 plugins
ln -s /usr/local/lib/lv2/Zyn*.lv2 $ZYNTHIAN_PLUGINS_DIR/lv2

#------------------------------------------------
# Install Fluidsynth & SondFonts
#------------------------------------------------
apt-get -y install fluidsynth fluid-soundfont-gm fluid-soundfont-gs

# Create SF2 soft links
cd $ZYNTHIAN_DATA_DIR/soundfonts/sf2
ln -s /usr/share/sounds/sf2/*.sf2 .

#------------------------------------------------
# Install Linuxsampler => TODO Upgrade to Version 2
#------------------------------------------------
apt-get -y install linuxsampler

#------------------------------------------------
# Install Fantasia (linuxsampler Java GUI)
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
mkdir fantasia
cd fantasia
wget --no-check-certificate http://downloads.sourceforge.net/project/jsampler/Fantasia/Fantasia%200.9/Fantasia-0.9.jar
# java -jar ./Fantasia-0.9.jar

#------------------------------------------------
# Install setBfree
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/pantherb/setBfree.git
cd setBfree
sed -i -- 's/-msse -msse2 -mfpmath=sse/-pipe -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -mvectorize-with-neon-quad -funsafe-loop-optimizations -funsafe-math-optimizations/g' common.mak
sed -i -- 's/^lv2dir = \$(PREFIX)\/lib\/lv2/lv2dir = \/zynthian\/zynthian-plugins\/lv2/' common.mak
make -j 4
make install

#------------------------------------------------
# Install MOD stuff
#------------------------------------------------

cd $ZYNTHIAN_SYS_DIR/scripts
./setup_mod.sh

#------------------------------------------------
# Install Plugins
#------------------------------------------------

cd $ZYNTHIAN_SYS_DIR/scripts
./setup_plugins_rbpi.sh


#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup a Zynthian Box from a raw debian-jessie installation
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

export ZYNTHIAN_HOME_DIR="/home/pi/zynthian"
export ZYNTHIAN_SW_DIR="$ZYNTHIAN_HOME_DIR/zynthian-sw"
export ZYNTHIAN_UI_DIR="$ZYNTHIAN_HOME_DIR/zynthian-ui"
export ZYNTHIAN_SYS_DIR="$ZYNTHIAN_HOME_DIR/zynthian-sys"
export ZYNTHIAN_DATA_DIR="$ZYNTHIAN_HOME_DIR/zynthian-data"

#------------------------------------------------
# Update System
#------------------------------------------------

sudo apt-get -y update
sudo apt-get -y upgrade
sudo rpi-update

#------------------------------------------------
# System Adjustments
#------------------------------------------------

# Remove Swap
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo sh -c "echo 'CONF_SWAPSIZE=0' > /etc/dphys-swapfile"

# Give permissions to Serial Port (UART)
sudo chmod a+rw /dev/ttyAMA0

# Boot config
sudo cp $ZYNTHIAN_SYS_DIR/boot/* /boot

# Modules
sudo cp $ZYNTHIAN_SYS_DIR/etc/modules /etc
sudo cp $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# Copy & Soft Link Init Scripts
sudo cp $ZYNTHIAN_SYS_DIR/etc/init.d/* /etc/init.d
sudo ln -s /etc/init.d/asplashscreen /etc/rcS.d/S01asplashscreen
sudo ln -s /etc/init.d/zynthian /etc/rc2.d/S01zynthian
sudo ln -s /etc/init.d/zynthian /etc/rc3.d/S01zynthian
sudo ln -s /etc/init.d/zynthian /etc/rc4.d/S01zynthian
sudo ln -s /etc/init.d/zynthian /etc/rc5.d/S01zynthian

# Systemd Services
#sudo systemctl disable serial-getty@ttyAMA0.service
#sudo systemctl disable sys-devices-platform-soc-3f201000.uart-tty-ttyAMA0.device
sudo systemctl disable raspi-config
sudo systemctl disable dphys-swapfile
sudo systemctl disable triggerhappy
sudo systemctl disable cron
#sudo systemctl disable avahi-daemon
#sudo systemctl disable dbus
sudo systemctl disable rsyslog
sudo systemctl disable ntp
sudo systemctl enable asplashscreen
sudo systemctl enable zynthian

# Initd Services
sudo cp $ZYNTHIAN_SYS_DIR/etc/inittab /etc
#sudo cp $ZYNTHIAN_DIR/etc/rc.local /etc
sudo update-rc.d -f raspi-config remove
sudo update-rc.d -f dphys-swapfile remove
sudo update-rc.d -f triggerhappy remove
sudo update-rc.d -f cron remove
#sudo update-rc.d -f avahi-daemon remove
#sudo update-rc.d -f dbus remove
sudo update-rc.d -f rsyslog remove
sudo update-rc.d -f ntp remove
sudo update-rc.d asplashscreen enable
sudo update-rc.d zynthian enable

# X11 Config
sudo mv /usr/share/X11/xorg.conf.d/99-fbturbo.conf /usr/share/X11/xorg.conf.d/99-fbturbo.nouse
sudo mkdir /etc/X11/xorg.conf.d
sudo cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
sudo cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# User
cp $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg ~/.zynaddsubfxXML.cfg
sudo cp $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

#------------------------------------------------
# Install Required Debian Packages
#------------------------------------------------

# CLI Tools
#sudo apt-get install tree # installed by default
sudo apt-get -y install joe
sudo apt-get -y install fbi
sudo apt-get -y install scrot # Screenshot Capture => installed by default
sudo apt-get -y install i2c-tools #==> !!!!REVISAR
#sudo apt-get install python-smbus (i2c with python)
sudo apt-get -y install evtest tslib libts-bin # touchscreen tools

# Autostatic Repos
wget -O - http://rpi.autostatic.com/autostatic.gpg.key| sudo apt-key add -
sudo wget -O /etc/apt/sources.list.d/autostatic-audio-raspbian.list http://rpi.autostatic.com/autostatic-audio-raspbian.list
sudo apt-get update

# Patched Versions of Jackd/Jackd2
#sudo apt-get --no-install-recommends install jackd1
#sudo apt-get --no-install-recommends install jackd2

sudo apt-get -y install jackd2 # installed by default
sudo apt-get -y install a2jmidid
sudo apt-get -y install laditools

# ZynAddSubFX (execution only)
sudo apt-get -y install libfltk1.3 libfltk-images1.3 liblo7 libmxml1

#------------------------------------------------
# Install PiTFT Software
#------------------------------------------------
#curl -SLs https://apt.adafruit.com/add | sudo bash
#sudo apt-get -y install raspberrypi-bootloader

#------------------------------------------------
# Create Directory Tree & 
# Install Zynthian Software from repository
#------------------------------------------------

mkdir $ZYNTHIAN_HOME_DIR
cd $ZYNTHIAN_HOME_DIR
git clone https://github.com/zynthian/zyncoder.git
mkdir zyncoder/build
cd zyncoder/build
cmake ..
make
cd $ZYNTHIAN_HOME_DIR
git clone https://github.com/zynthian/zynthian-ui.git
git clone https://github.com/zynthian/zynthian-sys.git
git clone https://github.com/zynthian/zynthian-data.git
#git clone https://github.com/zynthian/zynthian-plugins.git
mkdir "zynthian-sw"
mkdir "zynthian-my-data"
mkdir "zynthian-plugins"
mkdir "zynthian-plugins/lv2"
mkdir "zynthian-plugins/dssi"
mkdir "zynthian-plugins/vst"
mkdir "zynthian-plugins/ladspa"

#------------------------------------------------
# Development Environment
#------------------------------------------------
sudo apt-get -y install autoconf
sudo apt-get -y install libtool
sudo apt-get -y install cmake
sudo apt-get -y install premake
sudo apt-get -y install cmake-curses-gui

# Libraries
sudo apt-get -y install fftw3-dev
sudo apt-get -y install libmxml-dev
sudo apt-get -y install zlib1g-dev # installed by default
sudo apt-get -y install libasound2-dev
#sudo apt-get -y install libjack-dev
#sudo apt-get -y install libjack-dev-session
sudo apt-get -y install libjack-jackd2-dev
sudo apt-get -y install libfltk1.3-dev
sudo apt-get -y install libncurses-dev
sudo apt-get -y install liblo-dev
sudo apt-get -y install dssi-dev
sudo apt-get -y install libjpeg-dev
sudo apt-get -y install libxpm-dev
#sudo apt-get -y install libgd2-xpm-dev
sudo apt-get -y install liblash-compat-dev

sudo apt-get -y install fontconfig
sudo apt-get -y install fontconfig-config
sudo apt-get -y install libfontconfig1-dev
sudo apt-get -y install libxft-dev
sudo apt-get -y install libcairo-dev

#------------------------------------------------
# Python3 Modules
#------------------------------------------------
#sudo apt-get install python-dev
sudo apt-get -y install python3-dev # installed by default
sudo apt-get -y install python3-pip
sudo apt-get -y install cython3

#************************************************
#------------------------------------------------
# Compile / Install Other Required Software
#------------------------------------------------
#************************************************
#------------------------------------------------
# Install Alsaseq Python Library
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
wget https://pypi.python.org/packages/source/a/alsaseq/alsaseq-0.4.1.tar.gz
tar xfvz alsaseq-0.4.1.tar.gz
cd alsaseq-0.4.1
#sudo python setup.py install
sudo python3 setup.py install

#------------------------------------------------
# Install Python Jack Client Library
#------------------------------------------------
apt-get install python-cffi
sudo pip install JACK-Client
apt-get install python3-cffi
sudo pip3 install JACK-Client

#------------------------------------------------
# Install wiringPi
#------------------------------------------------
#cd $ZYNTHIAN_SW_DIR
#git clone git://git.drogon.net/wiringPi
#git pull origin
#./build

#------------------------------------------------
# Install NTK
#------------------------------------------------
#git clone git://git.tuxfamily.org/gitroot/non/fltk.git ntk
#cd ntk
#./waf configure
#./waf
#sudo ./waf install

#------------------------------------------------
# Install pyliblo (liblo OSC library for Python)
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/dsacre/pyliblo.git
cd pyliblo
python3 ./setup.py build
sudo python3 ./setup.py install

#------------------------------------------------
# Install rtosc library & oscprompt
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/fundamental/rtosc.git
cd rtosc
mkdir build
cd build
cmake ..
make -j 4
sudo make install

cd $ZYNTHIAN_SW_DIR
git clone https://github.com/fundamental/oscprompt.git
cd oscprompt
mkdir build
cd build
cmake ..
make -j 4
sudo make install

#------------------------------------------------
# Install TkinterTreectrl
#------------------------------------------------
sudo apt-get -y install tktreectrl
cd $ZYNTHIAN_SW_DIR
wget http://downloads.sourceforge.net/project/tkintertreectrl/TkinterTreectrl-2.0/TkinterTreectrl-2.0.1.zip
unzip TkinterTreectrl-2.0.1.zip
cd TkinterTreectrl-2.0.1
python3 setup.py build
sudo python3 setup.py install
#rm -f $ZYNTHIAN_SW_DIR/TkinterTreectrl-2.0.1.zip

#------------------------------------------------
# Install zynaddsubfx
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/fundamental/zynaddsubfx.git
cd zynaddsubfx
mkdir build
cd build
cmake ..
ccmake .
# => delete "-msse -msse2 -mfpmath=sse" 
# => optimizations: -pipe -mfloat-abi=hard -mfpu=neon-vfpv4 -mvectorize-with-neon-quad -funsafe-loop-optimizations -funsafe-math-optimizations
# => optimizations that doesn't work: -mcpu=cortex-a7 -mtune=cortex-a7
make -j 4
sudo make install

#Create soft link to zynbanks
cd $ZYNTHIAN_DATA_DIR
ln -s ../zynthian-sw/zynaddsubfx/instruments/banks zynbanks

#------------------------------------------------
# Install Fluidsynth & SondFonts
#------------------------------------------------
sudo apt-get install fluidsynth fluid-soundfont-gm fluid-soundfont-gs

# Create SF2 soft links
mkdir $ZYNTHIAN_DATA_DIR/soundfonts
mkdir $ZYNTHIAN_DATA_DIR/soundfonts/sf2
cd $ZYNTHIAN_DATA_DIR/soundfonts/sf2
ln -s /usr/share/sounds/sf2/*.sf2 .

#------------------------------------------------
# Install Linuxsampler => TODO: Compile version 2
#------------------------------------------------
sudo apt-get -y install linuxsampler
#sudo apt-get -y install qsampler => es una version 2.2, se compila de repositorio

#------------------------------------------------
# Install QSampler
#------------------------------------------------
#sudo apt-get -y install qt4-qmake qt5-qmake qtbase5-dev
#sudo ln -s /usr/lib/arm-linux-gnueabihf/qt5/bin/qmake /usr/bin/qmake-qt5
#sudo apt-get -y install libqt5x11extras5-dev qt4-linguist-tools
#sudo apt-get -y install liblscp-dev
#sudo apt-get -y install libgig-dev
#cd $ZYNTHIAN_SW_DIR
#git clone http://git.code.sf.net/p/qsampler/code qsampler
#cd qsampler
#make -f Makefile.git 
#./configure
#make
#sudo make install

#------------------------------------------------
# Install Fantasia (linuxsampler Java GUI)
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
mkdir fantasia
cd fantasia
wget http://downloads.sourceforge.net/project/jsampler/Fantasia/Fantasia%200.9/Fantasia-0.9.jar
# java -jar ./Fantasia-0.9.jar

#------------------------------------------------
# Install setBfree
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/pantherb/setBfree.git
cd setBfree
sed -i -- 's/\-msse \-msse2 \-mfpmath\=sse/\-pipe \-mcpu\=cortex\-a7 \-mfpu\=neon\-vfpv4 \-mfloat\-abi\=hard \-mvectorize\-with\-neon\-quad \-funsafe\-loop\-optimizations \-funsafe\-math\-optimizations/g' common.mak
make -j 4 ENABLE_ALSA=yes
sudo make install

#------------------------------------------------
# Install Carla
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/falkTX/Carla.git
cd Carla
make features
sudo apt-get install qt4-dev-tools
sudo apt-get install qt5-dev-tools
sudo apt-get install pyqt4-dev-tools
sudo apt-get install pyqt5-dev-tools
sudo apt-get install python3-pyqt4
sudo apt-get install python3-pyqt5
sudo apt-get install libgtk2.0-dev
sudo apt-get install libgtk-3-dev
#sudo apt-get install libgtk+2.0-dev
#sudo apt-get install gtk+3.0-dev
sudo apt-get install libfluidsynth-dev
sudo apt-get install fluidsynth-dssi
sudo apt-get install liblinuxsampler-dev
sudo apt-get install linuxsampler-lv2
sudo apt-get install linuxsampler-dssi
export RASPPI=true
make -j 4
sudo make install

#------------------------------------------------
# Install Dexed Plugin
#------------------------------------------------
sudo apt-get -y install x11proto-xinerama-dev libxinerama-dev libxcursor-dev
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/asb2m10/dexed.git
cd dexed/Builds/Linux
joe Makefile 
#=> -pipe -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -mvectorize-with-neon-quad -funsafe-loop-optimizations -funsafe-math-optimizations
export CONFIG=Release
make -j 4
make strip
cp ./build/Dexed.so ../../../../zynthian-plugins/vst

#------------------------------------------------
# Install DISTRHO Plugins-Ports
#------------------------------------------------
cd $ZYNTHIAN_DIR/zynthian-sw
git clone https://github.com/DISTRHO/DISTRHO-Ports.git
cd DISTRHO-Ports
./scripts/premake-update.sh linux
#edit ./scripts/premake.lua
make -j 4
sudo make install

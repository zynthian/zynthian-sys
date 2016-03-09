#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup a Zynthian Box from a raw debian-wheezy installation
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

ZYNTHIAN_DIR="/home/pi"
ZYNTHIAN_SW_DIR="/home/pi/zynthian"

#------------------------------------------------
# System Adjustments
#------------------------------------------------

mkdir $ZYNTHIAN_DIR/bak
sudo chmod a+rw /dev/ttyAMA0
sudo cp $ZYNTHIAN_SW_DIR/etc/modules /etc

# SystemV Init
sudo cp $ZYNTHIAN_SW_DIR/etc/init.d/* /etc/init.d
sudo cp $ZYNTHIAN_SW_DIR/etc/inittab /etc
#sudo cp $ZYNTHIAN_DIR/etc/rc.local /etc
ln -s /etc/init.d/asplashscreen /etc/rcS.d/S01asplashscreen
ln -s /etc/init.d/zynthian /etc/rc2.d/S01zynthian
ln -s /etc/init.d/zynthian /etc/rc3.d/S01zynthian
ln -s /etc/init.d/zynthian /etc/rc4.d/S01zynthian
ln -s /etc/init.d/zynthian /etc/rc5.d/S01zynthian
sudo update-rc.d asplashscreen enable
sudo update-rc.d zynthian enable
sudo update-rc.d -f avahi-daemon remove
sudo update-rc.d -f triggerhappy remove
sudo update-rc.d -f cron remove
sudo update-rc.d -f rsyslog remove
sudo update-rc.d -f dbus remove

# DISABLE wpa_supplicant ??? => No hace nada
sudo mv /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service $ZYNTHIAN_DIR/bak
sudo mv /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service $ZYNTHIAN_DIR/bak

# Systemd
# ...

# X11 Config
sudo mv /usr/share/X11/xorg.conf.d /usr/share/X11/xorg.conf.d.nouse
sudo mkdir /etc/X11/xorg.conf.d
sudo cp $ZYNTHIAN_SW_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
sudo cp $ZYNTHIAN_SW_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# User
cp $ZYNTHIAN_SW_DIR/etc/zynaddsubfxXML.cfg ~/.zynaddsubfxXML.cfg
sudo cp $ZYNTHIAN_SW_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

#------------------------------------------------
# Install Required Debian Packages
#------------------------------------------------

# Tools
sudo apt-get install screen
sudo apt-get install tree
sudo apt-get install joe
sudo apt-get install fbi
sudo apt-get install scrot # Screenshot Capture
sudo apt-get install i2c-tools
#sudo apt-get install python-smbus (i2c with python)

# Fluidsynth & SF2
sudo apt-get install fluidsynth fluid-soundfont-gm fluid-soundfont-gs
mkdir $ZYNTHIAN_DIR/sf2
ln -s /usr/share/sounds/sf2/* .

#------------------------------------------------
# Compile / Install Other Required Software
#------------------------------------------------

cd $ZYNTHIAN_SW_DIR/software
wget https://pypi.python.org/packages/source/a/alsaseq/alsaseq-0.4.1.tar.gz
tar xfvz alsaseq-0.4.1.tar.gz
cd alsaseq-0.4.1
#sudo python setup.py install
sudo python3 setup.py install

#cd $ZYNTHIAN_SW_DIR/software
#git clone git://git.drogon.net/wiringPi
#git pull origin
#./build

# ZynAddSubFX (execution only)
sudo apt-get install libfltk1.3 libfltk-images1.3 liblo7 libmxml1

#------------------------------------------------
# Install PiTFT Software
#------------------------------------------------
curl -SLs https://apt.adafruit.com/add | sudo bash
sudo apt-get install -y raspberrypi-bootloader

#------------------------------------------------
# Entorno de Desarrollo
#------------------------------------------------
sudo apt-get install autoconf
sudo apt-get install libtool
sudo apt-get install cmake
sudo apt-get install cmake-curses-gui

sudo apt-get install gcc-4.8 g++-4.8
sudo update-alternatives --remove-all gcc 
sudo update-alternatives --remove-all g++
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 20
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

# Libraries
#sudo apt-get install python-dev
sudo apt-get install python3-dev
sudo apt-get install fftw3-dev
sudo apt-get install libmxml-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libasound2-dev
sudo apt-get install libjack-dev
#sudo apt-get install libjack-dev-session
sudo apt-get install libfltk1.3-dev
sudo apt-get install libncurses-dev
#sudo apt-get install cython3 => Se instala con pip
#sudo apt-get install liblo-dev => Se compila desde el repositorio

#------------------------------------------------
# Patched Versions of Jackd/Jackd2
#------------------------------------------------
wget -O - http://rpi.autostatic.com/autostatic.gpg.key| sudo apt-key add -
sudo wget -O /etc/apt/sources.list.d/autostatic-audio-raspbian.list http://rpi.autostatic.com/autostatic-audio-raspbian.list
sudo apt-get update
sudo apt-get --no-install-recommends install jackd1
#sudo apt-get --no-install-recommends install jackd2
sudo apt-get install a2jmidid

#------------------------------------------------
# Módulos Python3
#------------------------------------------------
sudo apt-get install python3-pip
#sudo pip-3.2 install python-osc
sudo pip-3.2 install cython

#------------------------------------------------
# Install pyliblo (liblo OSC library for Python)
#------------------------------------------------
sudo apt-get remove liblo3
cd $ZYNTHIAN_SW_DIR/software
git clone git://git.code.sf.net/p/liblo/git liblo
cd liblo
./autogen.sh
make
sudo make install

cd $ZYNTHIAN_SW_DIR/software
git clone https://github.com/dsacre/pyliblo.git
cd pyliblo
python3 ./setup.py build
sudo python3 ./setup.py install


#------------------------------------------------
# Install rtosc library & oscprompt
#------------------------------------------------
cd $ZYNTHIAN_DIR/software
git clone https://github.com/fundamental/rtosc.git
cd rtosc
mkdir build
cd build
cmake ..
sudo make install

cd $ZYNTHIAN_DIR/software
git clone https://github.com/fundamental/oscprompt.git
cd oscprompt
mkdir build
cd build
cmake ..
sudo make install

#------------------------------------------------
# Install TkinterTreectrl
#------------------------------------------------
sudo apt-get install tktreectrl
cd $ZYNTHIAN_DIR/software
wget http://downloads.sourceforge.net/project/tkintertreectrl/TkinterTreectrl-2.0/TkinterTreectrl-2.0.1.zip
unzip TkinterTreectrl-2.0.1.zip
cd TkinterTreectrl-2.0.1
python3 setup.py build
sudo python3 setup.py install

#------------------------------------------------
# Install Linuxsampler
#------------------------------------------------
sudo apt-get install linuxsampler
sudo apt-get install qsampler

#------------------------------------------------
# Install Carla
#------------------------------------------------
cd $ZYNTHIAN_DIR/zynthian-sw
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
# Install DISTRHO Plugins-Ports
#------------------------------------------------
cd $ZYNTHIAN_DIR/zynthian-sw
git clone https://github.com/DISTRHO/DISTRHO-Ports.git
cd DISTRHO-Ports
sudo apt-get install premake
./scripts/premake-update.sh linux
#edit ./scripts/premake.lua
make -j 4




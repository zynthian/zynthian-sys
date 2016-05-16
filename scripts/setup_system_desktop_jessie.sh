#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup a Zynthian Development/Emulation in a fresh debian-jessie installation
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

#------------------------------------------------
# Create Zynthian Dir in Current Directory
#------------------------------------------------

export ZYNTHIAN_HOME_DIR="`pwd`/zynthian"
export ZYNTHIAN_SW_DIR="$ZYNTHIAN_HOME_DIR/zynthian-sw"
export ZYNTHIAN_UI_DIR="$ZYNTHIAN_HOME_DIR/zynthian-ui"
export ZYNTHIAN_SYS_DIR="$ZYNTHIAN_HOME_DIR/zynthian-sys"
export ZYNTHIAN_DATA_DIR="$ZYNTHIAN_HOME_DIR/zynthian-data"

#------------------------------------------------
# Update System
#------------------------------------------------

sudo apt-get -y update
sudo apt-get -y upgrade

#------------------------------------------------
# Add Repositories
#------------------------------------------------

# Install required dependencies if needed
sudo apt-get -y install apt-transport-https software-properties-common wget

# deb-multimedia repo
echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list
sudo apt-get -y install deb-multimedia-keyring
#sudo apt-get -y update
#sudo apt-get -y dist-upgrade

# KXStudio Repo
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_9.2.2~kxstudio1_all.deb
sudo dpkg -i kxstudio-repos_9.2.2~kxstudio1_all.deb
rm -f kxstudio-repos_9.2.2~kxstudio1_all.deb

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

sudo apt-get -y install jackd2 # installed by default
sudo apt-get -y install a2jmidid
sudo apt-get -y install laditools

# ZynAddSubFX (execution only)
sudo apt-get -y install libfltk1.3 libfltk-images1.3 liblo7 libmxml1

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
sudo apt-get -y install non-ntk-dev
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
# Compile / Install Other Required Libraries
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
sudo apt-get -y install python-cffi
sudo pip install JACK-Client
sudo apt-get -y install python3-cffi
sudo pip3 install JACK-Client

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

#************************************************
#------------------------------------------------
# Create Directory Tree & 
# Install Zynthian Software from repository
#------------------------------------------------
#************************************************

mkdir $ZYNTHIAN_HOME_DIR
cd $ZYNTHIAN_HOME_DIR
git clone https://github.com/zynthian/zyncoder.git
mkdir zyncoder/build
cd zyncoder/build
cmake ..
make
cd $ZYNTHIAN_HOME_DIR
git clone https://github.com/zynthian/zynthian-ui.git
echo "PROTOTYPE-EMU" > ./zynthian-ui/zynthian_hw_version.txt
git clone https://github.com/zynthian/zynthian-emuface.git
git clone https://github.com/zynthian/zynthian-data.git
mkdir "zynthian-sw"
mkdir "zynthian-my-data"
mkdir "zynthian-plugins"
mkdir "zynthian-plugins/lv2"
mkdir "zynthian-plugins/dssi"
mkdir "zynthian-plugins/vst"
mkdir "zynthian-plugins/ladspa"

#************************************************
#------------------------------------------------
# Compile / Install Other Required Software
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
ccmake .
make -j 4
sudo make install

#Create soft link to zynbanks
ln -s $ZYNTHIAN_SW_DIR/zynaddsubfx/instruments/banks $ZYNTHIAN_DATA_DIR/zynbanks

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
# Install Linuxsampler => TODO Upgrade to Version 2
#------------------------------------------------
sudo apt-get -y install linuxsampler
#sudo apt-get -y install qsampler => 2.2 is too old => compile from repo

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
make -j 4 ENABLE_ALSA=yes
sudo make install

#------------------------------------------------
# Install Carla
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/falkTX/Carla.git
cd Carla
make features
sudo apt-get -y install qt4-dev-tools
sudo apt-get -y install qt5-dev-tools
sudo apt-get -y install pyqt4-dev-tools
sudo apt-get -y install pyqt5-dev-tools
sudo apt-get -y install python3-pyqt4
sudo apt-get -y install python3-pyqt5
sudo apt-get -y install libgtk2.0-dev
sudo apt-get -y install libgtk-3-dev
#sudo apt-get -y install libgtk+2.0-dev
#sudo apt-get -y install gtk+3.0-dev
sudo apt-get -y install libfluidsynth-dev
sudo apt-get -y install fluidsynth-dssi
sudo apt-get -y install liblinuxsampler-dev
sudo apt-get -y install linuxsampler-lv2
sudo apt-get -y install linuxsampler-dssi
make -j 4
sudo make install

#------------------------------------------------
# The last 2 blocks can be omitted installing 
# the DISTRHO deb package: NOT WORKING!
#------------------------------------------------
#sudo apt-get install DISTRHO-plugins
#exit

#------------------------------------------------
# Install some extra LV2 Plugins (Calf, MDA, ...)
#------------------------------------------------
sudo apt-get install calf-plugins mda-lv2 swh-lv2 lv2vocoder avw.lv2

#------------------------------------------------
# Install DISTRHO DPF-Plugins
#------------------------------------------------
cd $ZYNTHIAN_DIR/zynthian-sw
git clone https://github.com/DISTRHO/DPF-Plugins.git
cd DPF-Plugins
make -j 4
sudo make install

#------------------------------------------------
# Install DISTRHO Plugins-Ports
#------------------------------------------------
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/DISTRHO/DISTRHO-Ports.git
cd DISTRHO-Ports
./scripts/premake-update.sh linux
#edit ./scripts/premake.lua
make -j 4
sudo make install

#------------------------------------------------
# Install Dexed Plugin => TODO Download VST2 SDK
#------------------------------------------------
sudo apt-get -y install x11proto-xinerama-dev libxinerama-dev libxcursor-dev
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/asb2m10/dexed.git
cd dexed/Builds/Linux
joe Makefile 
export CONFIG=Release
make -j 4
make strip
cp ./build/Dexed.so ../../../../zynthian-plugins/vst

#------------------------------------------------
# Install Aubio Library & Tools
#------------------------------------------------
sudo apt-get -y install libsamplerate-dev libsndfile-dev
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/aubio/aubio.git
cd aubio
make -j 4
sudo cp -f ./build/src/libaubio* /usr/lib64
sudo cp -f ./build/examples/aubiomfcc /usr/bin
sudo cp -f ./build/examples/aubionotes /usr/bin
sudo cp -f ./build/examples/aubioonset /usr/bin
sudo cp -f ./build/examples/aubiopitch /usr/bin
sudo cp -f ./build/examples/aubioquiet /usr/bin
sudo cp -f ./build/examples/aubiotrack /usr/bin


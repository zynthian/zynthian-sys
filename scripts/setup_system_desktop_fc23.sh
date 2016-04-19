#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup a Zynthian Development/Emulation in a fresh Fedora 23 installation 
# (may work with other Fedora versions)
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

sudo dnf update

#------------------------------------------------
# Add Repositories
#------------------------------------------------

#RPM Fusion
sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm

#Planet CCRMA
sudo rpm -Uvh http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetccrma/22/x86_64/planetccrma-repo-1.1-3.fc22.ccrma.noarch.rpm

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

sudo dnf -y unzip
sudo dnf -y install icedtea-web java-openjdk
sudo dnf -y install a2jmidid
sudo dnf -y install qjackctl
sudo dnf -y install laditools
sudo dnf -y install alsa-plugins-jack
sudo dnf -y install jack-keyboard jack-rack
sudo dnf -y install dssi-*
sudo dnf -y install ladspa-*
sudo dnf -y install lv2-*

#------------------------------------------------
# Development Environment
#------------------------------------------------
sudo dnf -y install autoconf
sudo dnf -y install libtool
sudo dnf -y install cmake
sudo dnf -y install premake
#sudo dnf -y install cmake-curses-gui

# Libraries
sudo dnf -y install fftw3-devel
sudo dnf -y install alsa-lib-devel
sudo dnf -y install jack-audio-connection-kit-devel
sudo dnf -y install lash lash-devel
sudo dnf -y install libXpm libXpm-devel
sudo dnf -y install libxml mxml libxml-devel mxml-devel
sudo dnf -y install fltk fltk-devel fltk-fluid fltk-static
sudo dnf -y install non-ntk non-ntk-fluid non-ntk-devel
sudo dnf -y install ncurses-devel
sudo dnf -y install liblo-devel
sudo dnf -y install ladspa dssi lv2 ladspa-devel dssi-devel lv2-devel
sudo dnf -y install vmpk

sudo dnf -y install libjpeg-devel
sudo dnf -y install fontconfig fontconfig-devel
sudo dnf -y install cairo cairo-devel
sudo dnf -y install qt3-designer kdevelop

#------------------------------------------------
# Python3 Modules
#------------------------------------------------
sudo dnf -y install python-devel
sudo dnf -y install python3-devel
sudo dnf -y install python3-tkinter
sudo dnf -y install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install cython

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
sudo dnf -y install python-cffi
sudo pip install JACK-Client
sudo dnf -y install python3-cffi
sudo pip3 install JACK-Client

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
sudo dnf -y install tktreectrl
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
sudo dnf -y install fluidsynth fluid-soundfont-gm fluid-soundfont-gs

# Create SF2 soft links
mkdir $ZYNTHIAN_DATA_DIR/soundfonts
mkdir $ZYNTHIAN_DATA_DIR/soundfonts/sf2
cd $ZYNTHIAN_DATA_DIR/soundfonts/sf2
ln -s /usr/share/soundfonts/*.sf2 .

#------------------------------------------------
# Install Linuxsampler => TODO Upgrade to Version 2
#------------------------------------------------
sudo dnf -y install linuxsampler
#sudo dnf -y install qsampler => 2.2 is too old => compile from repo

#------------------------------------------------
# Install QSampler
#------------------------------------------------
#sudo dnf -y install qt4-qmake qt5-qmake qtbase5-dev
#sudo ln -s /usr/lib/arm-linux-gnueabihf/qt5/bin/qmake /usr/bin/qmake-qt5
#sudo dnf -y install libqt5x11extras5-dev qt4-linguist-tools
#sudo dnf -y install liblscp-dev
#sudo dnf -y install libgig-dev
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
sudo dnf -y install PyQt-devel PyQt4-devel python3-PyQt-devel python3-PyQt4-devel
sudo dnf -y install qt5-qtbase-devel
sudo dnf -y install gtk3-devel gtk2-devel
sudo dnf -y install fluidsynth-devel fluidsynth-dssi
sudo dnf -y install linuxsampler-devel linuxsampler-dssi
make -j 4
sudo make install

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
sudo dnf -y install x11proto-xinerama-dev libxinerama-dev libxcursor-dev
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
sudo dnf -y install libsamplerate-devel libsndfile-devel
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

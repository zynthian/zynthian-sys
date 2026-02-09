#!/bin/bash

cd /root
wget https://download.opensuse.org/repositories/multimedia:/proaudio/Raspbian_12/arm64/vaporizer2-lv2_3.5.0+git.11.1c56c4b-1_arm64.deb
dpkg -i vaporizer2-lv2_3.5.0+git.11.1c56c4b-1_arm64.deb
#wget https://download.opensuse.org/repositories/multimedia:/proaudio/Raspbian_11/arm64/vaporizer2-lv2_3.4.5+git.17.569e0b9-2_arm64.deb
#dpkg -i vaporizer2-lv2_3.4.5+git.17.569e0b9-2_arm64.deb
rm -f vaporizer2*.deb


# Create system directories
mkdir -p /usr/share/Vaporizer2/Noises
mkdir -p /usr/share/Vaporizer2/Presets
mkdir -p /usr/share/Vaporizer2/Tables

# Install data files
cd /usr/share
wget "https://os.zynthian.org/plugins/aarch64/Vaporizer2-data.tar.xz"
tar xfv Vaporizer2-data.tar.xz
rm -f Vaporizer2-data.tar.xz

# Create user directories
mkdir -p /root/Documents/Vaporizer2/Noises
mkdir -p /root/Documents/Vaporizer2/Presets
mkdir -p /root/Documents/Vaporizer2/Tables

# Install presets from Trupiano
cd /root/Documents/Vaporizer2/Presets
wget https://www.vast-dynamics.com/sites/default/files/downloads/Preset%20Bank%20by%20Thomas%20Trupiano.zip
unzip "Preset Bank by Thomas Trupiano.zip"
mv Trupiano/Presets/* Trupiano
rm -rf Trupiano/Presets
rm -f "Preset Bank by Thomas Trupiano.zip"

exit

# Install factory presets
pip install github-clone
cd /usr/share/Vaporizer2
ghclone https://github.com/VASTDynamics/Vaporizer2/tree/main/VASTvaporizer/Presets
ghclone https://github.com/VASTDynamics/Vaporizer2/tree/main/VASTvaporizer/Tables
ghclone https://github.com/VASTDynamics/Vaporizer2/tree/main/VASTvaporizer/Noises

cd /usr/share/Vaporizer2/Presets
mkdir Factory
cd Factory
wget https://www.vast-dynamics.com/sites/default/files/downloads/Factory%20Presets.zip
unzip "Factory Presets.zip"
rm -f "Factory Presets.zip"

# Install WaveTables from PietW
cd /root/Documents/Vaporizer2/Tables
wget https://www.vast-dynamics.com/sites/default/files/downloads/Wavetables%20Vaporizer2%20by%20PietW.zip
unzip "Wavetables Vaporizer2 by PietW.zip"
rm -f "Wavetables Vaporizer2 by PietW.zip"

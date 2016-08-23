#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi
ZYNTHIAN_SYS_DIR="$ZYNTHIAN_DIR/zynthian-sys"
ZYNTHIAN_SW_DIR="$ZYNTHIAN_DIR/zynthian-sw"

echo "Updating system configuration ..."

# Remove Swap
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo sh -c "echo 'CONF_SWAPSIZE=0' > /etc/dphys-swapfile"

# Give permissions to Serial Port (UART)
sudo chmod a+rw /dev/ttyAMA0

# Boot Config 
# => Detect NO_ZYNTHIAN_UPDATE flag
no_update_config=`grep -e ^#NO_ZYNTHIAN_UPDATE /boot/config.txt`
# => Detect Audio Device and configure
audio_device_dtoverlay=`grep -e ^dtoverlay /boot/config.txt | while read -r line ; do
    if [[ $line != *"pi3-disable-bt"* &&  $line != *"i2s-mmap"* && $line != *"pitft"* ]]; then
        echo $line
    fi
done`
if [ -z "$audio_device_dtoverlay" ]; then
    audio_device_dtoverlay="dtoverlay=hifiberry-dacplus"
fi
echo "AUDIO DEVICE DTOVERLAY => $audio_device_dtoverlay"
if [ -z "$no_update_config" ]; then
	# => Copy files
	sudo cp $ZYNTHIAN_SYS_DIR/boot/* /boot
	# => Set (restore) Audio Device
	sudo sed -i -e "s/#AUDIO_DEVICE_DTOVERLAY/$audio_device_dtoverlay/g" /boot/config.txt
fi

# Modules configuration
sudo cp $ZYNTHIAN_SYS_DIR/etc/modules /etc
sudo cp $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# Init Scripts
sudo cp $ZYNTHIAN_SYS_DIR/etc/init.d/* /etc/init.d

# Inittab
sudo cp $ZYNTHIAN_SYS_DIR/etc/inittab /etc

# X11
if [ -d "/usr/share/X11/xorg.conf.d.nouse" ]; then
	sudo mv /usr/share/X11/xorg.conf.d.nouse /usr/share/X11/xorg.conf.d
	sudo mv /usr/share/X11/xorg.conf.d/99-fbturbo.conf /usr/share/X11/xorg.conf.d/99-fbturbo.nouse
fi
sudo cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
sudo cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# User Config
# Shell & Login Config
cp $ZYNTHIAN_SYS_DIR/etc/profile.zynthian /home/pi/.profile.zynthian
# ZynAddSubFX Config
cp $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /home/pi/.zynaddsubfxXML.cfg
sudo cp $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg
# Carla Config
cp $ZYNTHIAN_SYS_DIR/etc/Carla2.conf /home/pi/.config/falkTX
sudo cp $ZYNTHIAN_SYS_DIR/etc/Carla2.conf /root/.config/falkTX

# mod-ttymidi
if [ ! -d "$ZYNTHIAN_SW_DIR/mod-ttymidi" ]; then
	cd $ZYNTHIAN_SW_DIR
	git clone https://github.com/moddevices/mod-ttymidi.git
	cd mod-ttymidi
	sudo make install
fi

#!/bin/bash

source zynthian_envars.sh

echo "Changing repository branch to sonar2016 ..."
git config --global user.email "box@zynthian.org"
git config --global user.name "Zynthian Box"
cd $ZYNTHIAN_SYS_DIR
git fetch
git checkout sonar2016
cd $ZYNTHIAN_DIR/zynthian-ui
git fetch
git checkout sonar2016

echo "Updating system configuration ..."

# Boot Config 
# => Detect NO_ZYNTHIAN_UPDATE flag
no_update_config=`grep -e ^#NO_ZYNTHIAN_UPDATE /boot/config.txt`
# => Detect Audio Device and configure
audio_device_dtoverlay=`grep -e ^dtoverlay /boot/config.txt | while read -r line ; do
	if [[ $line != *"pi3-disable-bt"* && $line != *"pi3-miniuart-bt"* && $line != *"i2s-mmap"* && $line != *"pitft"*  ]]; then
		echo $line
	fi
done`
if [ -z "$audio_device_dtoverlay" ]; then
    audio_device_dtoverlay="dtoverlay=hifiberry-dacplus"
fi
echo "AUDIO DEVICE DTOVERLAY => $audio_device_dtoverlay"
if [ -z "$no_update_config" ]; then
	# => Copy files
	cp $ZYNTHIAN_SYS_DIR/boot/* /boot
	# => Set (restore) Audio Device
	sed -i -e "s/#AUDIO_DEVICE_DTOVERLAY/$audio_device_dtoverlay/g" /boot/config.txt
fi

# Copy "etc" config files
cp -a $ZYNTHIAN_SYS_DIR/etc/modules /etc
cp -a $ZYNTHIAN_SYS_DIR/etc/inittab /etc
cp -a $ZYNTHIAN_SYS_DIR/etc/dbus-1/* /etc/dbus-1
cp -a $ZYNTHIAN_SYS_DIR/etc/systemd/* /etc/systemd/system
cp -a $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# X11 Config
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# Copy fonts to system directory
cp -an $ZYNTHIAN_UI_DIR/fonts/* /usr/share/fonts/truetype

# User Config (root)
# => ZynAddSubFX Config
cp -a $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

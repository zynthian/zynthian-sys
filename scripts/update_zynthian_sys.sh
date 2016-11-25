#!/bin/bash

source zynthian_envars.sh

echo "Updating system configuration ..."

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
	cp $ZYNTHIAN_SYS_DIR/boot/* /boot
	# => Set (restore) Audio Device
	sed -i -e "s/#AUDIO_DEVICE_DTOVERLAY/$audio_device_dtoverlay/g" /boot/config.txt
fi

# Copy "etc" config files
cp $ZYNTHIAN_SYS_DIR/etc/modules /etc
cp $ZYNTHIAN_SYS_DIR/etc/inittab /etc
cp $ZYNTHIAN_SYS_DIR/etc/init.d/* /etc/init.d
cp $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# X11 Config
cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# User Config (root)
# => Shell & Login Config
cp $ZYNTHIAN_SYS_DIR/etc/profile.zynthian /root/.profile.zynthian
echo "source .profile.zynthian" >> /root/.profile
# => ZynAddSubFX Config
cp $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

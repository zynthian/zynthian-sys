#!/bin/bash

if [ -f "./zynthian_envars.sh" ]; then
	source "./zynthian_envars.sh"
elif [ -z "$ZYNTHIAN_SYS_DIR" ]; then
	source "/zynthian/zynthian-sys/scripts/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

echo "Updating System configuration ..."

#------------------------------------------------------------------------------
# Boot Config 
#------------------------------------------------------------------------------

cp $ZYNTHIAN_SYS_DIR/boot/cmdline.txt /boot

# Detect NO_ZYNTHIAN_UPDATE flag
no_update_config=`grep -e ^#NO_ZYNTHIAN_UPDATE /boot/config.txt`
if [ -z "$no_update_config" ]; then

	if [ "$SOUNDCARD_DTOVERLAY_OPTIONS" ]; then
		SOUNDCARD_DTOVERLAY_LINE="dtoverlay=$SOUNDCARD_DTOVERLAY, $SOUNDCARD_DTOVERLAY_OPTIONS"
	else
		SOUNDCARD_DTOVERLAY_LINE="dtoverlay=$SOUNDCARD_DTOVERLAY"
	fi
	echo "SOUNDCARD DTOVERLAY => $SOUNDCARD_DTOVERLAY_LINE"

	if [ "$DISPLAY_DTOVERLAY_OPTIONS" ]; then
		DISPLAY_DTOVERLAY_LINE="dtoverlay=$DISPLAY_DTOVERLAY,$DISPLAY_DTOVERLAY_OPTIONS"
	else
		DISPLAY_DTOVERLAY_LINE="dtoverlay=$DISPLAY_DTOVERLAY"
	fi
	echo "DISPLAY DTOVERLAY => $DISPLAY_DTOVERLAY_LINE"

	# Copy files
	cp $ZYNTHIAN_SYS_DIR/boot/config.txt /boot

	# Replace config vars
	sed -i -e "s/#SOUNDCARD_DTOVERLAY#/$SOUNDCARD_DTOVERLAY_LINE/g" /boot/config.txt
	sed -i -e "s/#DISPLAY_DTOVERLAY#/$DISPLAY_DTOVERLAY_LINE/g" /boot/config.txt
fi

#------------------------------------------------------------------------------
# System Config 
#------------------------------------------------------------------------------

# Copy "etc" config files
cp -a $ZYNTHIAN_SYS_DIR/etc/modules /etc
cp -a $ZYNTHIAN_SYS_DIR/etc/inittab /etc
cp -a $ZYNTHIAN_SYS_DIR/etc/network/* /etc/network
cp -a $ZYNTHIAN_SYS_DIR/etc/dbus-1/* /etc/dbus-1
cp -a $ZYNTHIAN_SYS_DIR/etc/systemd/* /etc/systemd/system
cp -a $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# X11 Config
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

# Replace config vars
FRAMEBUFFER_ESC="${FRAMEBUFFER//\//\\\/}"
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#JACKD_OPTIONS#/$JACKD_OPTIONS/g" /etc/systemd/system/jack2.service


# Copy fonts to system directory
cp -an $ZYNTHIAN_UI_DIR/fonts/* /usr/share/fonts/truetype

# User Config (root)
# => ZynAddSubFX Config
cp -a $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

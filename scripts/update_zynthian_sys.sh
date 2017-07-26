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
# Escape Config Variables to replace
#------------------------------------------------------------------------------

FRAMEBUFFER_ESC=${FRAMEBUFFER//\//\\\/}

#------------------------------------------------------------------------------
# Boot Config 
#------------------------------------------------------------------------------

cp $ZYNTHIAN_SYS_DIR/boot/cmdline.txt /boot

# Detect NO_ZYNTHIAN_UPDATE flag
no_update_config=`grep -e ^#NO_ZYNTHIAN_UPDATE /boot/config.txt`
if [ -z "$no_update_config" ]; then
	cp $ZYNTHIAN_SYS_DIR/boot/config.txt /boot

	echo "SOUNDCARD CONFIG => $SOUNDCARD_CONFIG"
	sed -i -e "s/#SOUNDCARD_CONFIG#/$SOUNDCARD_CONFIG/g" /boot/config.txt
	
	echo "DISPLAY CONFIG => $DISPLAY_CONFIG"
	sed -i -e "s/#DISPLAY_CONFIG#/$DISPLAY_CONFIG/g" /boot/config.txt
fi

# Copy extra overlays
cp $ZYNTHIAN_SYS_DIR/boot/overlays/* /boot/overlays
for file in $ZYNTHIAN_SYS_DIR/boot/overlays/*.dtb ; do
	cp "$file" "${file%.dtb}.dtbo"
done

#------------------------------------------------------------------------------
# System Config 
#------------------------------------------------------------------------------

# Copy "etc" config files
cp -a $ZYNTHIAN_SYS_DIR/etc/modules /etc
cp -a $ZYNTHIAN_SYS_DIR/etc/inittab /etc
cp -a $ZYNTHIAN_SYS_DIR/etc/network/* /etc/network
#cp -a $ZYNTHIAN_SYS_DIR/etc/wpa_supplicant/* /etc/wpa_supplicant
cp -a $ZYNTHIAN_SYS_DIR/etc/dbus-1/* /etc/dbus-1
cp -a $ZYNTHIAN_SYS_DIR/etc/systemd/* /etc/systemd/system
cp -a $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# X11 Config
rm -f /etc/X11/xorg.conf.d/99-pitft.conf
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-fbdev.conf /etc/X11/xorg.conf.d
cp -a $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/X11/xorg.conf.d/99-fbdev.conf

# Replace config vars
sed -i -e "s/#FRAMEBUFFER#/$FRAMEBUFFER_ESC/g" /etc/systemd/system/zynthian.service
sed -i -e "s/#JACKD_OPTIONS#/$JACKD_OPTIONS/g" /etc/systemd/system/jack2.service

# Generate FB splash screens
#$ZYNTHIAN_SYS_DIR/scripts/generate_fb_splash.sh

# Copy fonts to system directory
cp -an $ZYNTHIAN_UI_DIR/fonts/* /usr/share/fonts/truetype

# User Config (root)
# => ZynAddSubFX Config
cp -a $ZYNTHIAN_SYS_DIR/etc/zynaddsubfxXML.cfg /root/.zynaddsubfxXML.cfg

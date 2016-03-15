#!/bin/bash

if [ -n $ZYNTHIAN_DIR ]; then
	ZYNTHIAN_DIR="/home/pi/zynthian"
fi
ZYNTHIAN_SYS_DIR="$ZYNTHIAN_DIR/zynthian-sys"

echo "Updating system configuration ..."

# Remove Swap
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo echo "CONF_SWAPSIZE=0" > /etc/dphys-swapfile

# Give permissions to Serial Port (UART)
sudo chmod a+rw /dev/ttyAMA0

# Boot config
sudo cp $ZYNTHIAN_SYS_DIR/boot/* /boot

# Modules configuration
sudo cp $ZYNTHIAN_SYS_DIR/etc/modules /etc
sudo cp $ZYNTHIAN_SYS_DIR/etc/udev/rules.d/* /etc/udev/rules.d

# Init Scripts
sudo cp $ZYNTHIAN_SYS_DIR/etc/init.d/* /etc/init.d

# Inittab
sudo cp $ZYNTHIAN_SYS_DIR/etc/inittab /etc

# X11
if [ -d /usr/share/X11/xorg.conf.d.nouse ]; then
	sudo mv /usr/share/X11/xorg.conf.d.nouse /usr/share/X11/xorg.conf.d
	sudo mv /usr/share/X11/xorg.conf.d/99-fbturbo.conf /usr/share/X11/xorg.conf.d/99-fbturbo.nouse
fi
sudo cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d
sudo cp $ZYNTHIAN_SYS_DIR/etc/X11/xorg.conf.d/99-pitft.conf /etc/X11/xorg.conf.d

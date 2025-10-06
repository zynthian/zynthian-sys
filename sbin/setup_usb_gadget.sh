#!/bin/bash

# Enter configfs directory for USB gadgets
CONFIGFS_ROOT=/sys/kernel/config
MAC=`cat cat /sys/class/net/eth0/address`

cd "${CONFIGFS_ROOT}"/usb_gadget

# create gadget directory and enter it
if [ ! -d "./zynthian" ]; then
	mkdir ./zynthian
	cd ./zynthian

	# USB IDs => PidCodes Vendor ID, Zynthian PID number
	echo 0x1209 > idVendor
	echo 0x5242 > idProduct

	# USB strings, optional
	mkdir strings/0x409 # US English, others rarely seen
	echo "ZYNTHIAN" > strings/0x409/manufacturer
	echo "ZYNTHIAN" > strings/0x409/product
	echo "$MAC" > strings/0x409/serialnumber

	# create the (only) configuration
	mkdir configs/c.1 # dot and number mandatory

	# create the (only) function
	mkdir functions/midi.usb0

	# assign function to configuration
	ln -s functions/midi.usb0/ configs/c.1/

	# bind!
	udc_device=$(ls /sys/class/udc)
	echo $udc_device > UDC
else
	echo "Zynthian USB gadget already configured!"
fi

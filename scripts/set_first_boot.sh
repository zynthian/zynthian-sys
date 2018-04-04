#!/bin/bash

# Add First Boot Script to /etc/rc.local
echo "Adding first boot call to /etc/rc.local ..."
sed -i -- "s/exit 0/\/zynthian\/zynthian-sys\/scripts\/first_boot\.sh/" /etc/rc.local
echo "exit 0" >> /etc/rc.local

# Clean unneeded packages & apt cache
echo "Cleaning unused packages and cache ..."
apt-get -y autoremove
apt-get clean

# Delete configured wifi networks
echo "Deleting wifi networks ..."
cp -f $ZYNTHIAN_SYS_DIR/etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant

# Delete logs
echo "Deleting system logs ..."
for f in /var/log/* /var/log/**/* ; do
	if [ -f $f ]; then
		cat /dev/null > $f
	fi
done

# Clean history
echo "Cleaning shell history ..."
cat /dev/null > ~/.bash_history && history -c && history -w

# Message
echo "The system is going to halt. Extract the SD card and dump the image."
sleep 3

# Power Off
poweroff   

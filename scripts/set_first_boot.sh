#!/bin/bash

# Add First Boot Script to /etc/rc.local
echo "Adding first boot call to /etc/rc.local ..."
sed -i -- "s/exit 0/\/zynthian\/zynthian-sys\/scripts\/first_boot\.sh/" /etc/rc.local
echo "exit 0" >> /etc/rc.local

# Clean history
echo "Cleaning shell history ..."
history -c

# Borrar logs
echo "Cleaning system logs ..."
for f in /var/logs/*; do
	cat /dev/null > f
done

# Message
echo "The system is going to halt. Extract the SD card and dump the image."
sleep 3

# Power Off
poweroff

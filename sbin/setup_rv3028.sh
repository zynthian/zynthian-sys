#!/bin/bash

function wait_for_EEBusy_done {
   busy=$((0x80))
   while (( busy == 0x80 ))
   do
      status=$( i2cget -y 1 0x52 0x0E )
      busy=$((status & 0x80))
   done
}

rmmod rtc_rv3028

wait_for_EEBusy_done

# get current BSM config
ebreg=$( i2cget -y 1 0x52 0x37 )

# if it's not already configured
if [ "$ebreg" != "0x1c" ]; then
	echo "RTC RV3028: Configuring BSM to Level Switching Mode ..."

	# disable auto refresh
	register=$( i2cget -y 1 0x52 0x0F )
	writeback=$((register | 0x08))
	i2cset -y 1 0x52 0x0F $writeback

	# enable BSM in level switching mode
	writeback=$((ebreg | 0x0C))
	i2cset -y 1 0x52 0x37 $writeback

	# Reset EEPROM Backup Register to factory default
	#i2cset -y 1 0x52 0x37 0x10

	# update EEPROM
	i2cset -y 1 0x52 0x27 0x00
	i2cset -y 1 0x52 0x27 0x11

	wait_for_EEBusy_done

	# reenable auto refresh
	register=$( i2cget -y 1 0x52 0x0F )
	writeback=$((register & ~0x08))
	i2cset -y 1 0x52 0x0F $writeback

	wait_for_EEBusy_done
else
		echo "RTC RV3028: BSM already configured to Level Switching Mode."
fi

modprobe rtc_rv3028


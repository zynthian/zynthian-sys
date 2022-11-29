#!/bin/bash

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

if [ -f "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh" ]; then
    source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
    source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi

if [ -z "$1" ]; then
	bluetooth_mode=$ZYNTHIAN_BLUETOOTH_MODE
else
	bluetooth_mode=$1
fi

if [ -z "$bluetooth_mode" ]; then
    echo "BLUETOOTH Mode not set: Default to off"
    bluetooth_mode="off"
else
    echo "BLUETOOTH Mode => '$bluetooth_mode'"
fi

#------------------------------------------------------------------------------


if [ "$bluetooth_mode" == "off" ]; then
    systemctl stop bt-a2j
    systemctl stop bluealsa-aplay
    systemctl stop bluealsa
    systemctl stop bluetooth

elif [ "$bluetooth_mode" == "on" ]; then
    systemctl start bluetooth
    systemctl start bluealsa
    systemctl start bluealsa-aplay
    systemctl start bt-a2j

fi 

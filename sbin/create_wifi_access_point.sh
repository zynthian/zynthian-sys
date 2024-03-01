#!/bin/bash

AP_SSID=zynthian
AP_CON_NAME=zynthian-ap

echo "Creating WIFI Access Point connection '$AP_SSID'..."
nmcli con del $AP_CON_NAME &> /dev/null
nmcli con add type wifi ifname wlan0 mode ap con-name $AP_CON_NAME ssid $AP_SSID autoconnect false
nmcli con modify $AP_CON_NAME wifi.band bg
nmcli con modify $AP_CON_NAME wifi.channel 3
nmcli con modify $AP_CON_NAME wifi.cloned-mac-address 08:13:37:59:73:A3
nmcli con modify $AP_CON_NAME wifi-sec.key-mgmt wpa-psk
#nmcli con modify $AP_CON_NAME wifi-sec.proto rsn
#nmcli con modify $AP_CON_NAME wifi-sec.group ccmp
#nmcli con modify $AP_CON_NAME wifi-sec.pairwise ccmp
nmcli con modify $AP_CON_NAME wifi-sec.psk "opensynth"
nmcli con modify $AP_CON_NAME ipv4.method shared ipv4.address 192.168.69.1/24
nmcli con modify $AP_CON_NAME ipv6.method disabled

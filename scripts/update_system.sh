#!/bin/bash

echo "Updating system ..."
ntpdate time.fu-berlin.de
apt-get -y update
apt-get -y upgrade
#rpi-update

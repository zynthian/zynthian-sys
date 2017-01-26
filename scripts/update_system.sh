#!/bin/bash

htpdate 0.europe.pool.ntp.org

echo "Updating system ..."
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
#rpi-update

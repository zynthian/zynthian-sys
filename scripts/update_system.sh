#!/bin/bash

echo "Updating system ..."
sudo service ntp start
sleep 3
sudo apt-get -y update
sudo apt-get -y upgrade
sudo rpi-update

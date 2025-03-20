#!/bin/bash

#Install VLC and make it work as root

apt -y install vlc vlc-plugin-jack
sed -i 's/geteuid/getppid/' /usr/bin/vlc
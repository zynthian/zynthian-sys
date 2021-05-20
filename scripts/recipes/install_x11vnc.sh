#!/bin/bash

# Install x11vnc VNC server

apt install x11vnc
rm /etc/systemd/system/vncserver@\:1.service
rm /etc/systemd/system/novnc.service

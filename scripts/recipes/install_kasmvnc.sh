#!/bin/bash

# Install KasmVNC server: X display + web VNC client for the Zynthian UI in containers
# without a display (virtual_zynthian.service, zynthian-sys/etc/systemd).

version="1.5.2"
distro="bookworm"

if [ ${MACHINE_HW_NAME} = "aarch64" ]; then
	arch="arm64"
elif [ ${MACHINE_HW_NAME} = "x86_64" ]; then
	arch="amd64"
else
	exit 0
fi
filename="kasmvncserver_debian_${distro}_${version}_${arch}.deb"

cd $ZYNTHIAN_SW_DIR
wget "https://github.com/kasmtech/KasmVNC/releases/download/v$version/$filename"
apt install -y "./$filename"
rm -f "$filename"

# KasmVNC user "root" with write permission (keyboard & mouse), default zynthian password.
# Only if it doesn't exist yet: an existing (maybe changed) password is kept.
if ! grep -q "^root:" /root/.kasmpasswd 2>/dev/null; then
	echo -e "opensynth\nopensynth\n" | kasmvncpasswd -u root -w
fi

# Session startup: UI alone on display :0, standard X session (xfwm4 + panel, processor GUIs) on :1
mkdir -p /root/.vnc
cp -a $ZYNTHIAN_SYS_DIR/etc/kasmvnc/xstartup /root/.vnc/xstartup

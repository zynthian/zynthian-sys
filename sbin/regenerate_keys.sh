#!/bin/bash

if [ -d "$ZYNTHIAN_CONFIG_DIR" ]; then
	source "$ZYNTHIAN_CONFIG_DIR/zynthian_envars.sh"
else
	source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars.sh"
fi


# Delete webconf cookie secret for enforcing regeneration
echo "Removing current webconf cookie secret ..."
echo "A new webconf cookie secret will be generated on next request."
rm -f "$ZYNTHIAN_CONFIG_DIR/webconf_cookie_secret.txt"


# Regenerate Syste SSH keys
echo "Removing current system SSH keys ..."
rm -fv /etc/ssh/ssh_host_*
echo "Generating new system SSH keys ..."
DEBIAN_FRONTEND=noninteractive /usr/sbin/dpkg-reconfigure openssh-server
echo "Restarting SSH server ..."
systemctl restart ssh

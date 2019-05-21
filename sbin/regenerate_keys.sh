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
rm -f /etc/ssh/ssh_host_*
echo "Generating new system SSH keys ..."
#DEBIAN_FRONTEND=noninteractive /usr/sbin/dpkg-reconfigure openssh-server
ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key 
echo "Restarting SSH server ..."
systemctl restart ssh

#!/bin/bash

#Install VLC and make it work as root

tee /usr/local/bin/patch-vlc.sh > /dev/null <<'EOF'
#!/bin/sh
# Patch vlc to allow root user
# Check if vlc is installed (dpkg database)
if dpkg-query -W -f='${Status}' vlc 2>/dev/null | grep -q "install ok installed"; then
    sed -i 's/geteuid/getppid/' /usr/bin/vlc
fi
EOF

sudo chmod +x /usr/local/bin/patch-vlc.sh

sudo tee /etc/apt/apt.conf.d/90-patch-vlc > /dev/null <<'EOF'
DPkg::Post-Invoke { "/usr/local/bin/patch-vlc.sh"; };
EOF

apt -y install --reinstall vlc vlc-plugin-jack
#sed -i 's/geteuid/getppid/' /usr/bin/vlc
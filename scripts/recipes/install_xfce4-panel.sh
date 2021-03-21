#!/bin/bash

# Install xfce4-panel

# Installation is actually done by 00_install_package.sh
# Perform configuration steps

XFCE4_CONF_PATH="/root/.config/xfce4"

echo 'xsetroot -solid grey' > /root/.xsessionrc
echo 'test x"/usr/bin/xfce4-panel" && /usr/bin/xfce4-panel &' >> /root/.xsessionrc

mkdir -p $XFCE4_CONF_PATH/panel/launcher-2
cat > $XFCE4_CONF_PATH/panel/launcher-2/16162580183.desktop <<EOL
[Desktop Entry]
Name=Patchage
Comment=Connect audio and MIDI applications together and manage audio sessions
Exec=/root/launch.sh patchage -A
Terminal=false
Icon=patchage
Type=Application
Categories=AudioVideo;Audio;
X-XFCE-Source=file:///usr/share/applications/patchage.desktop
EOL

mkdir -p $XFCE4_CONF_PATH/panel/launcher-3
cat > $XFCE4_CONF_PATH/panel/launcher-3/16162617706.desktop <<EOL
[Desktop Entry]
Version=1.0
Exec=/root/launch.sh /usr/bin/xfce4-panel -p
Icon=xfce4-panel
Type=Application
Categories=XFCE;GTK;Settings;DesktopSettings;X-XFCE-SettingsDialog;X-XFCE-PersonalSettings;
OnlyShowIn=XFCE;
Terminal=false
StartupNotify=true
X-XfcePluggable=true
X-XfceHelpComponent=xfce4-panel
X-XfceHelpPage=preferences
Name=Panel
Name[en_GB]=Panel Config
Comment=Customize the panel
Comment[en_GB]=Customise the panel
X-XFCE-Source=file:///usr/share/applications/panel-preferences.desktop
EOL

mkdir -p $XFCE4_CONF_PATH/panel/launcher-4
cat > $XFCE4_CONF_PATH/panel/launcher-4/16162603755.desktop <<EOL
[Desktop Entry]
Version=1.0
Name=Window Manager
Name[en_GB]=Window Manager
Comment=Configure window behavior and shortcuts
Comment[en_GB]=Configure window behaviour and shortcuts
Exec=/root/launch.sh xfwm4-settings
Icon=xfwm4
Terminal=false
Type=Application
Categories=XFCE;GTK;Settings;DesktopSettings;X-XFCE-SettingsDialog;X-XFCE-PersonalSettings;
StartupNotify=true
OnlyShowIn=XFCE;
X-XfcePluggable=true
X-XfceHelpComponent=xfwm4
X-XfceHelpPage=preferences
X-XFCE-Source=file:///usr/share/applications/xfce-wm-settings.desktop
EOL

mkdir -p $XFCE4_CONF_PATH/panel/launcher-5
cat > $XFCE4_CONF_PATH/panel/launcher-5/16162603314.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Exec=exo-open --launch TerminalEmulator
Icon=utilities-terminal
StartupNotify=true
Terminal=false
Categories=Utility;X-XFCE;X-Xfce-Toplevel;
OnlyShowIn=XFCE;
X-AppStream-Ignore=True
Name=Terminal Emulator
Name[en_GB]=Terminal Emulator
Comment=Use the command line
Comment[en_GB]=Use the command line
X-XFCE-Source=file:///usr/share/applications/exo-terminal-emulator.desktop
EOL

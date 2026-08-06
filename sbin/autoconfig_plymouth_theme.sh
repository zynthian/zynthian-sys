#!/bin/bash

# Copy/Update plymouth theme
mkdir -p "/usr/share/plymouth/themes"
cp -au "$ZYNTHIAN_SYS_DIR/plymouth/zynspinner" "/usr/share/plymouth/themes"
cp -au "$ZYNTHIAN_SYS_DIR/plymouth/zynloganim" "/usr/share/plymouth/themes"
cp -au "$ZYNTHIAN_SYS_DIR/plymouth/zynloganim-inverted" "/usr/share/plymouth/themes"

if [[ "$(systemctl is-enabled first_boot)" != "enabled" ]]; then
  plymouth_theme="zynloganim"
  current_plymouth_theme=$(plymouth-set-default-theme) || true
  if [[ -n "$current_plymouth_theme" ]]; then
    if [[ "$current_plymouth_theme" !=  "$plymouth_theme" ]]; then
      echo "Configuring plymouth theme '$plymouth_theme' ..."
      plymouth-set-default-theme -R "$plymouth_theme"
    else
      echo "Plymouth theme already configured: $plymouth_theme"
    fi
  fi
fi

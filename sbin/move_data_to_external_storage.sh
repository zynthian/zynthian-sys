#!/bin/bash

MOUNT_PATH=$(lsblk -no MOUNTPOINT | grep "/media/")

if [ ! -z "$MOUNT_PATH" ]; then
  echo "Detected external storage at '$MOUNT_PATH'".
  read -p "Do you want to move user data, system soundfonts and collections to external storage at '$MOUNT_PATH'? (y/N): " response
  if [[ "${response,,}" == "y" ]]; then
    # Move sound library to external storage
    echo "Moving system soudnfonts to external storage ..."
    mv "/zynthian/zynthian-data/soundfonts" "$MOUNT_PATH"
    echo "Moving system collections to external storage ..."
    mv "/zynthian/zynthian-data/collections" "$MOUNT_PATH"
    echo "Moving user data to external storage ..."
    mv "/zynthian/zynthian-my-data" "$MOUNT_PATH"

    # Create symlinks to external storage => we have something better now!
    #ln -s "$MOUNT_PATH/soundfonts" "/zynthian/zynthian-data"
    #ln -s "$MOUNT_PATH/collections" "/zynthian/zynthian-data"
    #ln -s "$MOUNT_PATH/zynthian-my-data" "/zynthian"

    # Create empty folders to avoid errors when external storage is not connected
    mkdir -p "$ZYNTHIAN_DATA_DIR/soundfonts"
    mkdir -p "$ZYNTHIAN_DATA_DIR/soundfonts/sfz"
    mkdir -p "$ZYNTHIAN_DATA_DIR/soundfonts/sf2"
    mkdir -p "$ZYNTHIAN_DATA_DIR/collections"
    create_my_data_dirtree.sh

    # Enable dynamic media binding & update config
    set_envar.py "ZYNTHIAN_DYNAMIC_MEDIA_BIND" "1"
    update_zynthian_sys.sh
  fi
else
  echo "Not detected external storage!"
fi


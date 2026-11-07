#!/bin/bash

MOUNT_PATH=$(lsblk -no MOUNTPOINT | grep "/media/")

if [ ! -z "$MOUNT_PATH" ]; then
  echo "Detected external storage at '$MOUNT_PATH'".
  read -p "Do you want to move user data, system soundfonts and collections to external storage at '$MOUNT_PATH'? (y/N): " response
  if [[ "${response,,}" == "y" ]]; then
    echo "Moving system soudnfonts to external storage ..."
    mv "/zynthian/zynthian-data/soundfonts" "/media/$MOUNT_PATH"
    ln -s "/media/$MOUNT_PATH/soundfonts" "/zynthian/zynthian-data"
    echo "Moving system collections to external storage ..."
    mv "/zynthian/zynthian-data/collections" "/media/$MOUNT_PATH"
    ln -s "/media/$MOUNT_PATH/collections" "/zynthian/zynthian-data"
    echo "Moving user data to external storage ..."
    mv "/zynthian/zynthian-my-data" "/media/$MOUNT_PATH"
    ln -s "/media/$MOUNT_PATH/zynthian-my-data" "/zynthian"
  fi
else
  echo "Not detected external storage!"
fi

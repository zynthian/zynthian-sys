#!/bin/bash

ACTION=$1
FORK_FLAG=$2
MEDIA_BASE="/media"

# ====================================================================
# CONFIGURATION MAP: "External_Folder_Name" -> "Internal_Target_Path"
# ====================================================================
declare -A TARGET_MAP
TARGET_MAP["soundfonts"]="/zynthian/zynthian-data/soundfonts"
TARGET_MAP["collections"]="/zynthian/zynthian-data/collections"
TARGET_MAP["zynthian-my-data"]="/zynthian/zynthian-my-data"
# ====================================================================

# If udev explicitly passed the --fork flag, break completely out of
# the udev container namespace by spawning a decoupled transient systemd service.
if [ "$FORK_FLAG" = "--fork" ]; then
    exec 1> >(logger -t udev-media-manager) 2>&1
    echo "Udev requested fork for [$ACTION]. Spawning global namespace service..."

    # --property=MountFlags=shared ensures that mounts and unmounts
    # propagate globally, preventing device lockups on brute extractions.
    systemd-run --description="Udev Media Manager Transient Service" \
                --property=MountFlags=shared \
                /zynthian/zynthian-sys/sbin/dynamic-media-bind.sh "$ACTION" --running-forked &
    exit 0
fi

# If running manually, we skip the block above and print straight to the terminal
echo "Executing task synchronously for action: [$ACTION]"

case "$ACTION" in
    add)
        echo "Device inserted. Monitoring for filesystem mount..."
        ACTIVE_MOUNT=""

        # Loop up to 10 seconds waiting for the mount matrix to build
        for i in {1..10}; do
            ACTIVE_MOUNT=$(awk -v base="$MEDIA_BASE" '$2 ~ "^"base {print $2; exit}' /proc/mounts)
            if [ -n "$ACTIVE_MOUNT" ]; then
                break
            fi
            sleep 1
        done

        if [ -n "$ACTIVE_MOUNT" ]; then
            echo "Found active storage block: $ACTIVE_MOUNT. Processing target directory maps..."

            for ext_folder in "${!TARGET_MAP[@]}"; do
                internal_target="${TARGET_MAP[$ext_folder]}"
                bind_source="$ACTIVE_MOUNT/$ext_folder"

                if [ -d "$bind_source" ]; then
                    if ! mountpoint -q "$internal_target"; then
                        mkdir -p "$internal_target"
                        mount --bind "$bind_source" "$internal_target"
                        mount --make-private "$internal_target"
                        echo "Bound successfully: $bind_source -> $internal_target"
                    else
                        echo "Notice: $internal_target is already busy/mounted."
                    fi
                fi
            done
        else
            echo "Timeout reached. No partition registered under $MEDIA_BASE."
        fi
        ;;

    remove)
        echo "Device disconnected. Cleaning up ghost target bindings and parent media mounts..."

        # 1. Step one: Hunt down and cut our configured Zynthian internal target binds
        for retry in {1..3}; do
            while IFS= read -r line; do
                target_path=$(echo "$line" | awk '{print $5}')

                # Protect core system root directories
                [[ "$target_path" =~ ^/(proc|sys|dev|run|media) ]] && continue
                [[ "$target_path" == "/" ]] && continue

                for ext_folder in "${!TARGET_MAP[@]}"; do
                    configured_target="${TARGET_MAP[$ext_folder]}"

                    if [ "$target_path" = "$configured_target" ]; then
                        if mountpoint -q "$target_path"; then
                            echo "Severing internal bind link on target: $target_path"
                            umount -l -f "$target_path" 2>/dev/null
                        fi
                    fi
                done
            done < /proc/self/mountinfo
            sleep 0.2
        done

        # 2. Step two: Clean up stale zombie parent drive paths under /media
        # Instead of testing with 'ls', we look directly at /proc/mounts to see if the backing
        # hardware block device node (e.g. /dev/sda1) has disappeared from the OS.
        while IFS= read -r mount_line; do
            dev_node=$(echo "$mount_line" | awk '{print $1}')
            parent_mount=$(echo "$mount_line" | awk '$2 ~ "^'"$MEDIA_BASE"'/" {print $2}')

            if [ -n "$parent_mount" ]; then
                # If the mount exists under /media, but its hardware block file is GONE, it is a dead zombie!
                if [ ! -b "$dev_node" ]; then
                    echo "Discovered dead hardware block $dev_node for mount $parent_mount. Forcing kernel eject..."
                    umount -l -f "$parent_mount" 2>/dev/null
                    rmdir "$parent_mount" 2>/dev/null
                fi
            fi
        done < /proc/mounts

        echo "Full resilient cleanup lifecycle completed. Block layers fully cleared."
        ;;
    *)
        echo "Unknown action parameter specified. Exiting."
        exit 1
        ;;
esac

#!/bin/bash

INSTALLED_PACKAGES_DIR="$ZYNTHIAN_CONFIG_DIR/packages"
mkdir -p "$INSTALLED_PACKAGES_DIR"


shopt -s nullglob
cd /zynthian/zynthian-packages
for catdir in */; do
    echo "Category $catdir"
    cd "$catdir"
    for package in *; do
        #echo "Checking package '$package' ..."
        pack_script="$package/$package.sh"
        if [[ -f "$pack_script" ]]; then
            installed=$(bash "$pack_script" installed)
        else
            if [[ -d "$ZYNTHIAN_DATA_DIR/collections/$package" ]]; then
                installed="installed"
            else
                installed="not installed"
            fi
        fi
        if [[ "$installed" == "installed" ]]; then
            echo "Installed package '$package' ..."
            mkdir -p "$INSTALLED_PACKAGES_DIR/$catdir"
            cp -a "$package" "$INSTALLED_PACKAGES_DIR/$catdir"
        fi
    done
    cd ..
done
shopt -u nullglob

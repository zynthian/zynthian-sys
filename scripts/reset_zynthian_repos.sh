#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Reset Repositories script
#
# Reset zynthian repositories (fresh clone)
#
# Copyright (C) 2015-2026 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
#
#******************************************************************************

[ -n "$ZYNTHIAN_DIR" ] || ZYNTHIAN_DIR="/zynthian"

[ -n "$ZYNTHIAN_SYS_REPO" ] || ZYNTHIAN_SYS_REPO="https://github.com/zynthian/zynthian-sys.git"
[ -n "$ZYNTHIAN_UI_REPO" ] || ZYNTHIAN_UI_REPO="https://github.com/zynthian/zynthian-ui.git"
[ -n "$ZYNTHIAN_ZYNCODER_REPO" ] || ZYNTHIAN_ZYNCODER_REPO="https://github.com/zynthian/zyncoder.git"
[ -n "$ZYNTHIAN_WEBCONF_REPO" ] || ZYNTHIAN_WEBCONF_REPO="https://github.com/zynthian/zynthian-webconf.git"
[ -n "$ZYNTHIAN_DATA_REPO" ] || ZYNTHIAN_DATA_REPO="https://github.com/zynthian/zynthian-data.git"
[ -n "$ZYNTHIAN_HELP_REPO" ] || ZYNTHIAN_HELP_REPO="https://github.com/zynthian/zynthian-help.git"
[ -n "$ZYNTHIAN_PACKAGES_REPO" ] || ZYNTHIAN_PACKAGES_REPO="https://github.com/zynthian/zynthian-packages.git"

export ZYNTHIAN_BRANCH=$1
export ZYNTHIAN_SYS_BRANCH=$1

[ -n "$ZYNTHIAN_BRANCH" ] || ZYNTHIAN_BRANCH=$ZYNTHIAN_TESTING_BRANCH
[ -n "$ZYNTHIAN_SYS_BRANCH" ] || ZYNTHIAN_SYS_BRANCH=$ZYNTHIAN_TESTING_BRANCH
[ -n "$ZYNTHIAN_UI_BRANCH" ] || ZYNTHIAN_UI_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_ZYNCODER_BRANCH" ] || ZYNTHIAN_ZYNCODER_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_WEBCONF_BRANCH" ] || ZYNTHIAN_WEBCONF_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_DATA_BRANCH" ] || ZYNTHIAN_DATA_BRANCH=$ZYNTHIAN_BRANCH
[ -n "$ZYNTHIAN_HELP_BRANCH" ] || ZYNTHIAN_HELP_BRANCH=$ZYNTHIAN_BRANCH

#export git_options="--depth 1 --single-branch"
#export git_options="--depth 1"
#export git_options="--shallow-since='2 years'"
export git_options="--filter=blob:none"

cd "$ZYNTHIAN_DIR"

# Force resetting all repositories
if [[ "$2" == "ALL" ]]; then
	rm -rf "zynthian-sys"
	rm -rf "zyncoder"
	rm -rf "zynthian-ui"
	rm -rf "zynthian-webconf"
	rm -rf "zynthian-data"
	rm -rf "zynthian-help"
	rm -rf "zynthian-packages"
elif [[ -d "$2" ]]; then
	rm -rf "$2"
fi

# Zynthian System Scripts and Config files
if [ ! -d "zynthian-sys" ]; then
	cd "$ZYNTHIAN_DIR"
	echo git clone "${git_options}" -b "${ZYNTHIAN_SYS_BRANCH}" "${ZYNTHIAN_SYS_REPO}"
	git clone "${git_options}" -b "${ZYNTHIAN_SYS_BRANCH}" "${ZYNTHIAN_SYS_REPO}"
fi

# Zyncoder library
if [ ! -d "zyncoder" ]; then
	cd "$ZYNTHIAN_DIR"
	git clone "${git_options}" -b "${ZYNTHIAN_ZYNCODER_BRANCH}" "${ZYNTHIAN_ZYNCODER_REPO}"
	./zyncoder/build.sh
fi

# Zynthian UI
if [ ! -d "zynthian-ui" ]; then
	cd "$ZYNTHIAN_DIR"
	git clone "${git_options}" -b "${ZYNTHIAN_UI_BRANCH}" "${ZYNTHIAN_UI_REPO}"
	cd "$ZYNTHIAN_UI_DIR/zynlibs"
	./build.sh
fi

# Zynthian Webconf Tool
if [ ! -d "zynthian-webconf" ]; then
	cd "$ZYNTHIAN_DIR"
	git clone "${git_options}" -b "${ZYNTHIAN_WEBCONF_BRANCH}" "${ZYNTHIAN_WEBCONF_REPO}"
	regenerate_keys.sh webconf
fi

# Zynthian Data
if [ ! -d "zynthian-data" ]; then
	cd "$ZYNTHIAN_DIR"
	git clone "${git_options}" -b "${ZYNTHIAN_DATA_BRANCH}" "${ZYNTHIAN_DATA_REPO}"
fi

# Zynthian Help
if [ ! -d "zynthian-help" ]; then
	cd "$ZYNTHIAN_DIR"
	git clone "${git_options}" -b "${ZYNTHIAN_HELP_BRANCH}" "${ZYNTHIAN_HELP_REPO}"
fi

# Zynthian Packages
if [ ! -d "zynthian-packages" ]; then
	cd "$ZYNTHIAN_DIR"
	git clone "${git_options}" "${ZYNTHIAN_PACKAGES_REPO}"
fi


#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Software
# 
# + Update the Zynthian Software from repositories.
# + Install/update extra packages (recipes).
# + Reconfigure system.
# + Reboot when needed.
# 
# Copyright (C) 2015-2024 Fernando Moyano <jofemodo@zynthian.org>
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
# ****************************************************************************

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------
# Disable power save to run update at full speed
#------------------------------------------------------------------------------

powersave_control.sh off

#------------------------------------------------------------------------------
# If attached to stable tag-releases, check if already in the last tag
#------------------------------------------------------------------------------

if [[ "$ZYNTHIAN_STABLE_TAG" == "last" ]]; then
  for repo_dir in 'zynthian-ui' 'zynthian-sys' 'zynthian-webconf' 'zynthian-data' 'zyncoder' ; do
		echo "Checking '$repo_dir' for stable tag-releases ..."
    pushd /zynthian/$repo_dir > /dev/null
    # Take last tag
    #git remote update origin --prune
    git fetch --tags --all --prune --force
    readarray -t stags <<<$(sort <<<$(git tag -l $ZYNTHIAN_STABLE_BRANCH-*))
    last_stag=${stags[-1]}
    echo -e "\tlast release-tag: $last_stag"
    # Get current branch
    branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
    echo -e "\tcurrent branch: $branch"
    # Upgrade to last release tag if needed
    if [[ "$branch" != "$last_stag" ]]; then
      echo -e "Upgrading '$repo_dir' to tag release '$last_stag' ..."
      git checkout .
      git branch -D $last_stag
      git checkout tags/$last_stag -b $last_stag
      git branch -D $branch
    fi
    popd > /dev/null
  done

#------------------------------------------------------------------------------
# Pull from zynthian-sys repository ...
#------------------------------------------------------------------------------
else
  cd $ZYNTHIAN_SYS_DIR
  export ZYNTHIAN_SYS_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  echo "Updating zynthian-sys ($ZYNTHIAN_SYS_BRANCH)..."
  git checkout .
  git clean -f
  if [ "$RESET_ZYNTHIAN_REPOSITORIES" == "1" ]; then
    git merge --abort
    git fetch
    git reset --hard origin/$ZYNTHIAN_SYS_BRANCH
  elif [[ $ZYNTHIAN_SYS_BRANCH == $ZYNTHIAN_STABLE_BRANCH-* ]]; then
    echo -e "Repository 'zynthian-sys' frozen in tag release '$ZYNTHIAN_SYS_BRANCH'!"
  else
    git pull
  fi
fi

#------------------------------------------------------------------------------
# Call update subscripts ...
#------------------------------------------------------------------------------

cd $ZYNTHIAN_SYS_DIR/scripts
./update_zynthian_sys.sh
./update_zynthian_recipes.sh
./update_zynthian_data.sh
./update_zynthian_sys.sh
./update_zynthian_code.sh

# Force restart of UI & webconf services
set_restart_ui_flag
set_restart_webconf_flag

run_flag_actions
sync

echo "Update Complete."

#------------------------------------------------------------------------------

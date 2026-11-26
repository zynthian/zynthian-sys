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

UPDATE_UNIT="zynthian-update"
UPDATE_LOG="/tmp/zynthian_update.log"
UPDATE_STATE_DIR="/run/zynthian_update"

#------------------------------------------------------------------------------
# Launcher: run the update detached, in a transient systemd unit, so it
# survives stopping/restarting the UI or webconf that launched it, and so
# services can be stopped and restored (ExecStopPost) even if the update fails.
# The caller follows the update log, so its progress display keeps working.
#------------------------------------------------------------------------------

function update_unit_running() {
	local state
	state=$(systemctl show -p ActiveState --value "$UPDATE_UNIT" 2> /dev/null)
	[[ "$state" == "active" || "$state" == "activating" || "$state" == "deactivating" || "$state" == "reloading" ]]
}

function follow_update() {
	local line tail_pid
	exec 3< <(tail -n +1 -F "$UPDATE_LOG" 2> /dev/null)
	tail_pid=$!
	while true; do
		if IFS= read -r -t 2 line <&3; then
			[[ "$line" == "EOUPDATE" ]] && break
			echo "$line"
		elif ! update_unit_running; then
			# Unit finished: print what's left in the log and stop
			while IFS= read -r -t 1 line <&3; do
				[[ "$line" == "EOUPDATE" ]] && break
				echo "$line"
			done
			break
		fi
	done
	kill $tail_pid 2> /dev/null
	exec 3<&-
	[[ "$(cat "$UPDATE_STATE_DIR/result" 2> /dev/null)" == "0" ]]
}

if [[ "$ZYNTHIAN_UPDATE_DETACHED" != "1" && -d /run/systemd/system ]] && command -v systemd-run > /dev/null; then
	if update_unit_running; then
		echo "An update is already running. Showing its progress..."
		follow_update
		exit $?
	fi

	# Keep webconf running if it launched the update (we are in its cgroup)
	keep_webconf=${ZYNTHIAN_UPDATE_KEEP_WEBCONF:-0}
	if grep -q "zynthian-webconf.service" /proc/self/cgroup 2> /dev/null; then
		keep_webconf=1
	fi

	# Run copies of the scripts: the originals are replaced by "git pull" during the update
	rm -rf "$UPDATE_STATE_DIR"
	mkdir -p "$UPDATE_STATE_DIR"
	cp "$0" "$UPDATE_STATE_DIR/update_zynthian.sh"
	cp "$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_services.sh" "$UPDATE_STATE_DIR/update_zynthian_services.sh"
	: > "$UPDATE_LOG"

	# Transient units don't inherit the environment. Don't pass the flags that make the
	# sourced scripts skip their setup: the unit must detect hardware, enter the venv, etc.
	env_args=()
	for name in $(compgen -e); do
		if [[ ( "$name" == ZYNTHIAN_* && "$name" != "ZYNTHIAN_FLAG_MASTER" && "$name" != "ZYNTHIAN_EXTENDED_ENVARS_DEFINED" ) || "$name" == "PATH" || "$name" == "HOME" || "$name" == "LANG" || "$name" == "FRAMEBUFFER" || "$name" == "VIRTUALIZATION" ]]; then
			env_args+=("--setenv=$name=${!name}")
		fi
	done

	echo "Starting update ($UPDATE_UNIT service). Log: $UPDATE_LOG"
	if systemd-run --unit="$UPDATE_UNIT" --collect --quiet \
		--property=StandardOutput="append:$UPDATE_LOG" \
		--property=StandardError="append:$UPDATE_LOG" \
		--property=ExecStopPost="/bin/bash $UPDATE_STATE_DIR/update_zynthian_services.sh restore" \
		"${env_args[@]}" \
		--setenv=ZYNTHIAN_UPDATE_DETACHED=1 \
		--setenv=ZYNTHIAN_UPDATE_KEEP_WEBCONF=$keep_webconf \
		/bin/bash "$UPDATE_STATE_DIR/update_zynthian.sh" "$@"; then
		follow_update
		exit $?
	fi
	if update_unit_running; then
		echo "An update is already running. Showing its progress..."
		follow_update
		exit $?
	fi
	echo "WARNING: Can't start the update service. Running the update directly..."
	rm -rf "$UPDATE_STATE_DIR"
fi

source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

mkdir -p "$UPDATE_STATE_DIR" 2> /dev/null
if [[ "$ZYNTHIAN_UPDATE_DETACHED" == "1" ]]; then
	SERVICES_SCRIPT="$UPDATE_STATE_DIR/update_zynthian_services.sh"
else
	SERVICES_SCRIPT="$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_services.sh"
fi

UPDATE_STEPS=9
update_step=0
update_errors=()

function progress() {
	update_step=$((update_step + 1))
	/bin/bash "$SERVICES_SCRIPT" progress "Updating [$update_step/$UPDATE_STEPS] $((100 * (update_step - 1) / UPDATE_STEPS))%: $*"
}

function run_step() {
	"$@"
	local res=$?
	if [[ $res -ne 0 ]]; then
		echo "WARNING: '$*' exited with code $res"
		update_errors+=("$*")
	fi
}

#------------------------------------------------------------------------------
# Check the repositories can be reached before stopping anything
#------------------------------------------------------------------------------

progress "Checking for Internet"
if ! timeout 30 git -C "$ZYNTHIAN_SYS_DIR" ls-remote -q origin HEAD > /dev/null 2>&1; then
	echo "ERROR: Can't reach the zynthian repositories. Check the Internet connection. Update cancelled."
	/bin/bash "$SERVICES_SCRIPT" progress "Update cancelled: no Internet"
	echo "cancelled" > "$UPDATE_STATE_DIR/result" 2> /dev/null
	exit 1
fi

#------------------------------------------------------------------------------
# Free RAM on low-memory devices: stop non-essential services.
# They are restored by the update unit's ExecStopPost, also on failure.
#------------------------------------------------------------------------------

progress "Preparing"
stopped_services=0
if [[ "$ZYNTHIAN_UPDATE_DETACHED" == "1" ]] && /bin/bash "$SERVICES_SCRIPT" low_mem; then
	echo "Low memory device: the UI and other services are stopped during the update and restarted after it."
	/bin/bash "$SERVICES_SCRIPT" stop
	stopped_services=1
fi

#------------------------------------------------------------------------------
# Disable power save to run update at full speed
#------------------------------------------------------------------------------

powersave_control.sh off

#------------------------------------------------------------------------------
# If attached to stable tag-releases, check if already in the last tag
#------------------------------------------------------------------------------

progress "Updating zynthian-sys"

if [[ "$ZYNTHIAN_STABLE_TAG" == "last" ]]; then
  for repo_dir in 'zynthian-ui' 'zynthian-sys' 'zynthian-webconf' 'zynthian-data' 'zyncoder' ; do
		echo "Checking '$repo_dir' for stable tag-releases ..."
    pushd /zynthian/$repo_dir > /dev/null
    # Take last tag
    #git remote update origin --prune
    git fetch --tags --all --prune --prune-tags --force
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
# Set/Reset patchlevel if specified ...
#------------------------------------------------------------------------------

if [[ "$1" == "--from" ]]; then
  echo "$2" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
elif [[ "$1" == "--reset" ]]; then
  echo "" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
fi

#------------------------------------------------------------------------------
# Call update subscripts ...
#------------------------------------------------------------------------------

cd $ZYNTHIAN_SYS_DIR/scripts
progress "System configuration"
run_step ./update_zynthian_sys.sh
progress "Software packages"
run_step ./update_zynthian_recipes.sh
progress "Data files"
run_step ./update_zynthian_data.sh
progress "System configuration"
run_step ./update_zynthian_sys.sh
progress "Zynthian software"
run_step ./update_zynthian_code.sh

# Force restart of UI & webconf services
set_restart_ui_flag
set_restart_webconf_flag

if [[ "$stopped_services" == "1" ]]; then
	# The stopped services (UI included) are started after this script ends,
	# by the restore action. Webconf, if kept running, is restarted last.
	clean_restart_ui_flag
	if [[ -f "$RESTART_WEBCONF_FLAGFILE" ]]; then
		clean_restart_webconf_flag
		touch "$UPDATE_STATE_DIR/restart_webconf"
	fi
	if [[ -f "$REBOOT_FLAGFILE" ]]; then
		# Rebooting brings everything back
		rm -f "$UPDATE_STATE_DIR/stopped_services"
		/bin/bash "$SERVICES_SCRIPT" progress "Update complete. Rebooting..."
	fi
fi

progress "Finishing"
sync

if [[ ${#update_errors[@]} -gt 0 ]]; then
	echo "WARNING: Some update steps reported problems: ${update_errors[*]}"
fi
# Rebooting stops this unit: record the result first
if [[ -f "$REBOOT_FLAGFILE" ]]; then
	echo "${#update_errors[@]}" > "$UPDATE_STATE_DIR/result" 2> /dev/null
fi

run_flag_actions
sync

echo "${#update_errors[@]}" > "$UPDATE_STATE_DIR/result" 2> /dev/null

if [[ "$ZYNTHIAN_UPDATE_DETACHED" != "1" ]]; then
	echo "Update Complete."
fi

#------------------------------------------------------------------------------


aptpkgs=""

# 2022-06-07: Install sfizz from repo
#res=`dpkg -s sfizz 2>&1 | grep "Status:"`
#if [ "$res" != "Status: install ok installed" ]; then
#	aptpkgs="$aptpkgs sfizz"
#fi

# 2023-07-19: Install ffmpeg-python (capture log)
#if is_python_module_installed.py ffmpeg-python; then
#	aptpkgs="$aptpkgs ffmpeg"
#	pip3 install ffmpeg-python
#fi

# -----------------------------------------------------------------------------
# Install/update recipes shouldn't be added below this line!
# -----------------------------------------------------------------------------

# Install needed apt packages
if [ ! -z "$aptpkgs" ]; then
	apt-get -y update --allow-releaseinfo-change
	apt-get -y install $aptpkgs
fi

# Upgrade System
if [[ ! "$ZYNTHIAN_SYS_BRANCH" =~ ^stable.* ]] || [[ "$ZYNTHIAN_FORCE_UPGRADE" == "yes" ]]; then
	if [ -z "$aptpkgs" ]; then
		apt-get -y update --allow-releaseinfo-change
	fi
	#dpkg --configure -a # => Recover from broken upgrade
	apt-get -y upgrade
fi

apt-get -y autoremove
apt-get -y autoclean

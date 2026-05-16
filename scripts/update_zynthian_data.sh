#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Update Zynthian Data
#
# + Update the Zynthian Data from repositories.
# + Perform some extra fixes
#
# Copyright (C) 2015-2017 Fernando Moyano <jofemodo@zynthian.org>
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
# Pull from repositories ...
#------------------------------------------------------------------------------

echo "Updating zynthian-data..."
cd "$ZYNTHIAN_DATA_DIR"
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
git checkout .
git clean -f
if [ "$RESET_ZYNTHIAN_REPOSITORIES" == "1" ]; then
	git merge --abort
	git fetch
	git reset --hard origin/$branch
elif [[ $branch == $ZYNTHIAN_STABLE_BRANCH-* ]]; then
  echo -e "Repository 'zynthian-data' frozen in tag release '$branch'!"
else
	git pull
fi

#------------------------------------------------------------------------------
# Fixing some paths & locations ...
#------------------------------------------------------------------------------

# Create collections directory
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/collections" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/collections"
fi

# Create directories and symlinks for Hydrogen soundfonts
if [ ! -d "$ZYNTHIAN_DATA_DIR/soundfonts/hydrogen" ]; then
	mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/hydrogen"
fi
if [ ! -d "/usr/share/drmr" ]; then
	mkdir "/usr/share/drmr"
fi
if [ ! -L "/usr/share/drmr/drumkits" ]; then
	ln -s "$ZYNTHIAN_DATA_DIR/soundfonts/hydrogen" "/usr/share/drmr/drumkits"
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/soundfonts/hydrogen" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/hydrogen"
fi
if [ ! -d "/usr/local/share/drmr" ]; then
	mkdir "/usr/local/share/drmr"
fi
if [ ! -L "/usr/local/share/drmr/drumkits" ]; then
	ln -s "$ZYNTHIAN_MY_DATA_DIR/soundfonts/hydrogen" "/usr/local/share/drmr/drumkits"
fi

# Move VPO3 soundfonts to own bank.
# This will break snapshots depending on these soundfonts,
# but it's "needed" to avoid too nested SFZ files.
if [ -d "$ZYNTHIAN_DATA_DIR/soundfonts/sfz/Other/VPO3-perf" ]; then
	mv "$ZYNTHIAN_DATA_DIR/soundfonts/sfz/Other/VPO3-perf" "$ZYNTHIAN_DATA_DIR/soundfonts/sfz/"
fi

# Create dir structure for UI file selector
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files"
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/IRs" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/IRs"
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Neural Models"
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Tuning"
	if [ -d "$ZYNTHIAN_MY_DATA_DIR/files/mod-ui/" ]; then
		mv $ZYNTHIAN_MY_DATA_DIR/files/mod-ui/* $ZYNTHIAN_MY_DATA_DIR/files/IRs
		rm -rf "$ZYNTHIAN_MY_DATA_DIR/files/mod-ui"
	fi
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/IRs/deconvolved" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/IRs/deconvolved"
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/Samples" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Samples"
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Samples/Percussion"
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Samples/One-Shot"
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Samples/Loops"
fi
if [ -L "$ZYNTHIAN_MY_DATA_DIR/files/Samples/capture" ]; then
	rm "$ZYNTHIAN_MY_DATA_DIR/files/Samples/capture"
fi
# Create audio data dir and soft-link capture as a subdir inside
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/Audio" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Audio"
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Audio/Tracks"
	ln -s "$ZYNTHIAN_MY_DATA_DIR/capture" "$ZYNTHIAN_MY_DATA_DIR/files/Audio/capture"
fi
# Manage old audio folder
if [ -d "$ZYNTHIAN_MY_DATA_DIR/audio" ]; then
	if [ -L "$ZYNTHIAN_MY_DATA_DIR/audio/capture" ]; then
		rm -rf "$ZYNTHIAN_MY_DATA_DIR/audio/capture"
	fi
	mv $ZYNTHIAN_MY_DATA_DIR/audio/* "$ZYNTHIAN_MY_DATA_DIR/files/Audio"
	rm -rf "$ZYNTHIAN_MY_DATA_DIR/audio"
fi
# Create MIDI folder and move some mid files to it
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/Midi" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Midi"
	mv "$ZYNTHIAN_MY_DATA_DIR/capture/Bladerunner-1.mid" "$ZYNTHIAN_MY_DATA_DIR/files/Midi"
	mv "$ZYNTHIAN_MY_DATA_DIR/capture/House In RTP.mid" "$ZYNTHIAN_MY_DATA_DIR/files/Midi"
	mv "$ZYNTHIAN_MY_DATA_DIR/capture/Money_for_nothing.mid" "$ZYNTHIAN_MY_DATA_DIR/files/Midi"
	mv "$ZYNTHIAN_MY_DATA_DIR/capture/roland_take5.mid" "$ZYNTHIAN_MY_DATA_DIR/files/Midi"
	mv "$ZYNTHIAN_MY_DATA_DIR/capture/useless.mid" "$ZYNTHIAN_MY_DATA_DIR/files/Midi"
fi
# Create Midi Capture soft link
if [ ! -L "$ZYNTHIAN_MY_DATA_DIR/files/Midi/capture" ]; then
	ln -s "$ZYNTHIAN_MY_DATA_DIR/capture" "$ZYNTHIAN_MY_DATA_DIR/files/Midi/capture"
fi
# Create Midi patterns subdir
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/Midi/patterns" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Midi/patterns"
fi

# Create soft links for puredata and SFZ samples
if [ ! -L "$ZYNTHIAN_MY_DATA_DIR/files/Samples/puredata" ]; then
	ln -s $ZYNTHIAN_MY_DATA_DIR/presets/puredata $ZYNTHIAN_MY_DATA_DIR/files/Samples
fi
if [ ! -L "$ZYNTHIAN_MY_DATA_DIR/files/Samples/sfz" ]; then
	ln -s $ZYNTHIAN_MY_DATA_DIR/soundfonts/sfz $ZYNTHIAN_MY_DATA_DIR/files/Samples
fi
if [ ! -L "$ZYNTHIAN_MY_DATA_DIR/files/Samples/hydrogen" ]; then
	ln -s $ZYNTHIAN_MY_DATA_DIR/soundfonts/hydrogen $ZYNTHIAN_MY_DATA_DIR/files/Samples/hydrogen
fi

# Move zynseq patterns to files
if [ -d "$ZYNTHIAN_MY_DATA_DIR/zynseq/patterns" ]; then
	mv "$ZYNTHIAN_MY_DATA_DIR/zynseq/patterns" "$ZYNTHIAN_MY_DATA_DIR/files/Patterns"
	#rm -rf "$ZYNTHIAN_MY_DATA_DIR/zynseq"
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/files/Patterns" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/files/Patterns"
fi

# Create preset-favorites if needed
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/preset-favorites" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/preset-favorites"
fi

# Create presets directory for SysEx if needed
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/presets/sysex" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/sysex"
fi

# Create presets directory symlink for TAL-U-NO-LX if needed
if [ ! -L "$ZYNTHIAN_MY_DATA_DIR/presets/TAL-U-No-LX" ]; then
	ln -s "/root/.toguaudioline/TAL-U-No-LX/presets" "$ZYNTHIAN_MY_DATA_DIR/presets/TAL-U-No-LX"
fi

# Create directory for JV880 emulator (ROM firmware & presets)
if [ ! -d "/root/.config/JV880" ]; then
  mkdir "/root/.config/JV880"
fi

# Fix ZynAddSubFX config & presets directories
if [ -L "/usr/local/share/zynaddsubfx" ]; then
	rm -f "/usr/local/share/zynaddsubfx"
fi
if [ -L "$ZYNTHIAN_MY_DATA_DIR/zynbanks" ]; then
	rm -f "$ZYNTHIAN_MY_DATA_DIR/zynbanks"
fi
if [ -d "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/XMZ" ]; then
	rm -rf "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/XMZ"
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/banks" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/banks"
fi
if [ ! -d "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/presets" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/presets"
fi
# Update presets from zynthian-data repository
cp -nr $ZYNTHIAN_DATA_DIR/presets/zynaddsubfx/banks/* /usr/share/zynaddsubfx/banks

# Fix/Setup MOD-UI pedalboards directory: create dirs & symlinks, copy pedalboards ...
if [ -d "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards" ]; then
	mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui"
	mv "$ZYNTHIAN_MY_DATA_DIR/mod-pedalboards" "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards"
fi
cp -na $ZYNTHIAN_DATA_DIR/presets/mod-ui/pedalboards/*.pedalboard $ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards
rm -f "/root/.pedalboards"
ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards" "/root/.pedalboards"

# Fix/Setup MOD-UI lv2 presets directory
if [ -d "/root/.lv2" ] && [ ! -L "/root/.lv2" ]; then
	mv /root/.lv2/* $ZYNTHIAN_MY_DATA_DIR/presets/lv2 2>/dev/null; true
	rm -rf "/root/.lv2"
	ln -s "$ZYNTHIAN_MY_DATA_DIR/presets/lv2" "/root/.lv2"
fi

# Fix/Setup setbfree user config directory
if [ -d "$ZYNTHIAN_MY_DATA_DIR/setbfree" ]; then
	mv "$ZYNTHIAN_MY_DATA_DIR/setbfree" $ZYNTHIAN_CONFIG_DIR
fi

# Fix LV2 Plugins
if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/b_whirl" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/b_whirl.lv2"
	mv "$ZYNTHIAN_PLUGINS_DIR/lv2/b_whirl" "$ZYNTHIAN_PLUGINS_DIR/lv2/b_whirl.lv2"
fi
if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/b_synth" ]; then
	rm -rf "$ZYNTHIAN_PLUGINS_DIR/lv2/b_synth.lv2"
	mv "$ZYNTHIAN_PLUGINS_DIR/lv2/b_synth" "$ZYNTHIAN_PLUGINS_DIR/lv2/b_synth.lv2"
fi

# Fix LV2 Presets
if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2" ]; then
	sed -i -- 's/a pset\:bank/a pset\:Bank/g' $ZYNTHIAN_PLUGINS_DIR/lv2/amsynth.lv2/*.ttl
fi
if [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/dexed.lv2" ]; then
	sed -i -- 's/a pset\:bank/a pset\:Bank/g' $ZYNTHIAN_PLUGINS_DIR/lv2/dexed.lv2/*.ttl
fi
sed -i -- 's/a pset\:bank/a pset\:Bank/g' $ZYNTHIAN_MY_DATA_DIR/presets/lv2/*/*.ttl

# Link FluidPlug SF2s for using normally with FluidSynth
cd $ZYNTHIAN_PLUGINS_DIR/lv2
for d in AirFont320* AVL_Drumkits_Perc* Black_Pearl* Fluid* Red_Zeppelin*; do
	name=${d%.*}
	dest=$ZYNTHIAN_DATA_DIR/soundfonts/sf2/$name.sf2
	if [[ ( ! -L "$dest") && ( $name != "FluidGM" ) ]]; then
		echo "Linking $name.sf2 ..."
		ln -s "$ZYNTHIAN_PLUGINS_DIR/lv2/$d/FluidPlug.sf2" "$dest"
	fi
done

# Create and link emulator ROM directories
roms_dir="$ZYNTHIAN_SW_DIR/filebrowser/root/roms"
tus_dir="/root/.local/share/The Usual Suspects"
if [ ! -d "/root/.config/JV880" ]; then
	mkdir -p "/root/.config/JV880"
fi
if [ ! -d "$tus_dir/Osirus/roms" ]; then
	mkdir -p "$tus_dir/Osirus/roms"
fi
if [ ! -d "$tus_dir/OsTIrus/roms" ]; then
	mkdir -p "$tus_dir/OsTIrus/roms"
fi
if [ ! -d "$tus_dir/Vavra/roms" ]; then
	mkdir -p "$tus_dir/Vavra/roms"
fi
if [ ! -d "$tus_dir/Xenia/roms" ]; then
	mkdir -p "$tus_dir/Xenia/roms"
fi
if [ ! -d "$roms_dir" ]; then
	mkdir -p "$roms_dir"
fi
if [ ! -L "$roms_dir/JV880" ]; then
	ln -s "/root/.config/JV880" "$roms_dir/JV880"
fi
if [ ! -L "$roms_dir/Osirus" ]; then
	ln -s "$tus_dir/Osirus/roms" "$roms_dir/Osirus"
fi
if [ ! -L "$roms_dir/OsTIrus" ]; then
	ln -s "$tus_dir/OsTIrus/roms" "$roms_dir/OsTIrus"
fi
if [ ! -L "$roms_dir/Vavra" ]; then
	ln -s "$tus_dir/Vavra/roms" "$roms_dir/Vavra"
fi
if [ ! -L "$roms_dir/Xenia" ]; then
	ln -s "$tus_dir/Xenia/roms" "$roms_dir/Xenia"
fi

# Copy PD binary libraries
cp -a $ZYNTHIAN_DATA_DIR/puredata/pd-externals-arm64/* /usr/local/lib/pd-externals

# Copy custom TTL files
cd "$ZYNTHIAN_DATA_DIR/lv2-custom"
for d in */; do
	cd "$ZYNTHIAN_DATA_DIR/lv2-custom/$d"
	if [ -d "/usr/lib/lv2/$d" ]; then
		cp -a * "/usr/lib/lv2/$d"
	elif [ -d "/usr/local/lib/lv2/$d" ]; then
		cp -a * "/usr/local/lib/lv2/$d"
	elif [ -d "$ZYNTHIAN_PLUGINS_DIR/lv2/$d" ]; then
		cp -a * "$ZYNTHIAN_PLUGINS_DIR/lv2/$d"
	fi
done

run_flag_actions

#------------------------------------------------------------------------------

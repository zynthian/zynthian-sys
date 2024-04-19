#!/bin/bash

#------------------------------------------------------------------------------
# Script to generate LV2 preset-banks from the generated LV2 factory and
# third party presets
#------------------------------------------------------------------------------

plugin_url="https://surge-synthesizer.github.io/lv2/surge-xt"
plugin_dir="/usr/local/lib/lv2/Surge XT.lv2"

cd "$plugin_dir"

#------------------------------------------------------------------------------
# Split presets from manifest
#------------------------------------------------------------------------------
cp manifest.ttl maniback.ttl
n=$(wc -l maniback.ttl | cut -d ' ' -f 1)
m=$(grep -n 'rdfs:seeAlso <ui.ttl> .' maniback.ttl | cut -d : -f 1)
n=$((n-m))
m=$((m+1))
sed -n '/^@/p' maniback.ttl > /tmp/presets.ttl
echo -e "" >> /tmp/presets.ttl
head maniback.ttl -n $m > manifest.ttl

# Get bank list from preset labels
readarray -t plabels <<< $(grep 'rdfs:label' maniback.ttl | cut -d \" -f 2)
declare -a preset_labels
declare -a preset_banks
declare -a preset_titles
for key in "${!plabels[@]}"; do
	plabel=${plabels[$key]}
	if [ "$plabel" != "" ]; then
		preset_labels+=("$plabel")
		part1=$(echo $plabel | cut -d \/ -f 1)
		part2=$(echo $plabel | cut -d \/ -f 2)
		part3=$(echo $plabel | cut -d \/ -f 3)
		if [ "$part3" == "" ]; then
			preset_banks+=("$part1")
			preset_titles+=("$part2")
			#echo "BANK: $part1"
			#echo "FACTORY PRESET: $part2"
		else
			preset_banks+=("$part2")
			preset_titles+=("$part1/$part3")
			#echo "BANK: $part2"
			#echo "3RD PARTY PRESET: $part1/$part3"
		fi
		#echo ""
	fi
done

# Add Bank definitions
readarray -t banks <<< $(printf "%s\n" "${preset_banks[@]}" | sort -u)
for key in "${!banks[@]}"; do
	echo -e "" >> /tmp/presets.ttl
	echo -e "<$plugin_url:bank$key>" >> /tmp/presets.ttl
	echo -e "\tlv2:appliesTo <$plugin_url> ;" >> /tmp/presets.ttl
	echo -e "\ta pset:Bank ;" >> /tmp/presets.ttl
	echo -e "\trdfs:label \"${banks[$key]}\" ." >> /tmp/presets.ttl
done

# Generate banks reverse index
declare -A banks_index
for i in "${!banks[@]}"; do
	banks_index["${banks[$i]}"]=$i
done

# Add original preset definitions
tail maniback.ttl -n -$n >> /tmp/presets.ttl

# Add Bank to preset definitions and change label
for key in "${!preset_labels[@]}"; do
	preset_label=${preset_labels[$key]}
	preset_label_esc=${preset_label//\&/\\\&}
	preset_title=${preset_titles[$key]}
	preset_title_esc=${preset_title//\&/\\\&}
	bank_label=${preset_banks[$key]}
	bindex=${banks_index["$bank_label"]}
	echo "BANK=$bank_label($bindex) / PRESET $preset_title"
	sed -i "s#rdfs\:label \"$preset_label_esc\"#pset\:bank <$plugin_url\:bank$bindex> ;\n\trdfs\:label \"$preset_title_esc\"#" /tmp/presets.ttl
done

# Move presets file from tmp to LV2 folder
mv /tmp/presets.ttl factory_presets.ttl

# Add seeAlso line to manifest.ttl
sed -i "s#rdfs\:seeAlso <dsp.ttl>#rdfs\:seeAlso <factory_presets.ttl> ;\n\trdfs\:seeAlso <dsp.ttl>#" manifest.ttl

rm -f maniback.ttl

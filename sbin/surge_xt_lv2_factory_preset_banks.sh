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
sed -n '/^@/p' maniback.ttl > factory_presets.ttl
echo -e "" >> factory_presets.ttl
head maniback.ttl -n $m > manifest.ttl

# Get bank list from preset labels
sed -i "s/ \/ /%/g" maniback.ttl
readarray -t parts <<< $(grep 'rdfs:label' maniback.ttl | cut -d \" -f 2 | cut -d '%' -f 1)
readarray -t preset_banks <<< $(printf "%s\n" "${parts[@]}" | sort -u)

# Add Bank definitions
for key in "${!preset_banks[@]}"; do
	echo -e "" >> factory_presets.ttl
	echo -e "<$plugin_url:bank$key>" >> factory_presets.ttl
	echo -e "\tlv2:appliesTo <$plugin_url> ;" >> factory_presets.ttl
	echo -e "\ta pset:Bank ;" >> factory_presets.ttl
	echo -e "\trdfs:label \"${preset_banks[$key]}\" ." >> factory_presets.ttl
done

# Add preset definitions
tail maniback.ttl -n -$n >> factory_presets.ttl

# Add Bank to preset definitions
for key in "${!preset_banks[@]}"; do
	bank_label=${preset_banks[$key]}
	sed -i "s#rdfs\:label \"$bank_label\%#pset\:bank <$plugin_url\:bank$key> ;\n\trdfs\:label \"$bank_label \/ #g" factory_presets.ttl
done

# Add seeAlso line to manifest.ttl
sed -i "s#rdfs\:seeAlso <dsp.ttl>#rdfs\:seeAlso <factory_presets.ttl> ;\n\trdfs\:seeAlso <dsp.ttl>#g" manifest.ttl

rm -f maniback.ttl

#!/bin/bash

#------------------------------------------------------------------------------
# Script to generate LV2 preset-banks from the generated LV2 factory and
# third party presets
#------------------------------------------------------------------------------

plugin_url="https://surge-synthesizer.github.io/lv2/MoniqueMonosynth"
plugin_dir="/usr/local/lib/lv2/MoniqueMonosynth.lv2"

cd "$plugin_dir"

#------------------------------------------------------------------------------
# Split presets from manifest
#------------------------------------------------------------------------------
n=$(wc -l manifest.ttl | cut -d ' ' -f 1)
m=$(grep -n 'rdfs:seeAlso <ui.ttl> .' manifest.ttl | cut -d : -f 1)
n=$((n-m))
m=$((m+1))
if [[ "$n" < "100" ]]; then
	echo "Already done!"
	exit
else
	echo "Let's start!!"
fi
cp manifest.ttl maniback.ttl
sed -n '/^@/p' maniback.ttl > /tmp/presets.ttl
echo -e "" >> /tmp/presets.ttl
head maniback.ttl -n $m > manifest.ttl

# Add Bank definitions
banks=("factory")
for key in "${!banks[@]}"; do
	echo -e "" >> /tmp/presets.ttl
	echo -e "<$plugin_url:bank$key>" >> /tmp/presets.ttl
	echo -e "\tlv2:appliesTo <$plugin_url> ;" >> /tmp/presets.ttl
	echo -e "\ta pset:Bank ;" >> /tmp/presets.ttl
	echo -e "\trdfs:label \"${banks[$key]}\" ." >> /tmp/presets.ttl
done

# Add original preset definitions
tail maniback.ttl -n -$n >> /tmp/presets.ttl

# Add Bank to preset definitions
sed -i "s#rdfs\:label#pset\:bank <$plugin_url\:bank0> ;\n\trdfs\:label#" /tmp/presets.ttl

# Move presets file from tmp to LV2 folder
mv /tmp/presets.ttl factory_presets.ttl

# Add seeAlso line to manifest.ttl
sed -i "s#rdfs\:seeAlso <dsp.ttl>#rdfs\:seeAlso <factory_presets.ttl> ;\n\trdfs\:seeAlso <dsp.ttl>#" manifest.ttl

rm -f maniback.ttl

#!/bin/sh

# sfz file renames...
# -h lists options
# -f fakes the process but dumps to a log file what it would do
# Please remove the -f below to actually perform the changes.
# pyparsing will need to be installed

pip3 install pyparsing
cd /zynthian/zynthian-sys/pyscripts

file="sfz_include_file_handle.log"
if [ ! -f "$file" ]
then
    echo "$0: File '${file}' not found."
else
    rm $file
fi
echo "Processing zynthian-data"
python3 sfz_include_file_handle.py -f /zynthian/zynthian-data/soundfonts/sfz/
# echo "Processing zynthian-my-data"
# python3 sfz_include_file_handle.py -f /zynthian/zynthian-my-data/soundfonts/sfz/

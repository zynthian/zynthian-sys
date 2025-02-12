#!/bin/bash

cd "$ZYNTHIAN_MY_DATA_DIR/files/Neural Models"
git clone https://github.com/pelennor2170/NAM_models

AUTHORS=( "George B" "Helga B" "Jason Z" "Keith B" "Luis R" "Mikhail K" "Peter N" "Phillipe P" "Roman A" "Sascha S" "Tim R" "Tom C" "Tudor N")
for auth in "${AUTHORS[@]}"; do
	mkdir "$auth"
	mv "NAM_models/$auth"* "$auth/"
	cp "NAM_models/COPYING" "$auth/"
done

rm -rf "NAM_models"

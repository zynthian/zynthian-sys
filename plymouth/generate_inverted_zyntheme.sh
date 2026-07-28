#!/bin/bash

theme=$1

mkdir "$theme-inverted"
cd $theme
for img in *.png; do
	convert "$img" -flip -flop "../$theme-inverted/$img"
done
cp "$theme.plymouth" "../$theme-inverted/$theme-inverted.plymouth"
cp "$theme.script" "../$theme-inverted/$theme-inverted.script"
sed -i "s/zynloganim/zynloganim-inverted/g" "../$theme-inverted/$theme-inverted.plymouth"

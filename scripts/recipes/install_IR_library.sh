#!/bin/bash

echo "Installing Conners Impulse Reponse Library..."
cd $ZYNTHIAN_DATA_DIR/files
rm -rf IRs
wget https://github.com/itsmusician/IR-Library/releases/download/v2.0.0/Conners-IR-Library_v2.0.0.zip
unzip Conners-IR-Library_v2.0.0.zip
rm -f Conners-IR-Library_v2.0.0.zip
mv IR-Library-main IRs

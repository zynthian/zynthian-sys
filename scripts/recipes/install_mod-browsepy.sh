#!/bin/bash

# browsepy
cd $ZYNTHIAN_SW_DIR
rm -rf browsepy
git clone https://github.com/moddevices/browsepy.git
cd browsepy 

pip3 install scandir backports.shutil-get-terminal-size
pip3 install ./

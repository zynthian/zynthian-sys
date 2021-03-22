#!/bin/bash

# Jamulus
cd $ZYNTHIAN_SW_DIR
git clone https://github.com/jamulussoftware/jamulus.git --branch r3_7_0 jamulus
cd jamulus

qmake "CONFIG+=headless" Jamulus.pro
make all
make install
make clean

# Prepare Jamulus.ini
JAMULUSINIFILE="/root/Jamulus.ini"
NAME64=$(echo "Raspi $(hostname)"|cut -c -16|tr -d $'\n'|base64)
echo -e "<client>" > ${JAMULUSINIFILE}
echo -e "  <name_base64>${NAME64}</name_base64>" >> ${JAMULUSINIFILE}
echo -e "  <autojitbuf>1</autojitbuf>" >> ${JAMULUSINIFILE}
echo -e "  <jitbuf>3</jitbuf>" >> ${JAMULUSINIFILE}
echo -e "  <jitbufserver>3</jitbufserver>" >> ${JAMULUSINIFILE}
echo -e "  <audiochannels>2</audiochannels>" >> ${JAMULUSINIFILE}
echo -e "  <audioquality>1</audioquality>" >> ${JAMULUSINIFILE}
echo -e "</client>" >> ${JAMULUSINIFILE}


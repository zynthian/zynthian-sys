#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "terminado" ]; then
	rm -rf "terminado"
fi

pip3 install tornado_xstatic
# The next command prints an error that i don't know how to avoid, so i send the error to /dev/null for avoid breaking nightly builds
pip3 install xstatic 2>/dev/null 
pip3 install XStatic_term.js

git clone https://github.com/jupyter/terminado.git
cd terminado
python3 ./setup.py install
cd ..

#rm -rf "terminado"

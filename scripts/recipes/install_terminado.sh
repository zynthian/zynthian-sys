#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "terminado" ]; then
	rm -rf "terminado"
fi

pip3 install tornado_xstatic
pip3 install xstatic
pip3 install XStatic_term.js

git clone https://github.com/jupyter/terminado.git
cd terminado
python3 ./setup.py install
cd ..

#rm -rf "terminado"

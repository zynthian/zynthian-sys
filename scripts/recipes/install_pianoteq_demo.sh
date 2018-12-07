#!/bin/bash

cd $ZYNTHIAN_SW_DIR
wget http://blog.zynthian.org/download/pianoteq6_demo.tar.xz
tar xfvJ pianoteq6_demo.tar.xz
mv pianoteq6_demo pianoteq6
rm pianoteq6_demo.tar.xz
cd pianoteq6
ln -s "./Pianoteq 6 STAGE" pianoteq
ln -s "$ZYNTHIAN_SW_DIR/pianoteq6/Pianoteq 6 STAGE.lv2" "$ZYNTHIAN_PLUGINS_DIR/lv2"

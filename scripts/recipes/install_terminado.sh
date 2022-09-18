#!/bin/bash


pip3 install tornado_xstatic xstatic

# The next command prints an error that i don't know how to avoid, so i send the error to /dev/null for avoid breaking nightly builds
pip3 install XStatic_term.js 2>/dev/null

# Last terminado version compatible with tornado-4.1 is 0.13.3
pip3 install terminado==0.13.3

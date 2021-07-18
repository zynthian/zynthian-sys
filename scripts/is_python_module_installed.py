#!/usr/bin/python3
#	Check if a Python module is installed
#	Usage: is_python_module_installed.py module_name
#
#	Exit code 1 if installed (or no module specified)
#
#	2021 Brian Walton (riban@zynthian.org)

import sys
import pkg_resources

try:
    module = sys.argv[1]
except:
    sys.exit(1)

if module in {pkg.key for pkg in pkg_resources.working_set}:
    sys.exit(1)
else:
    sys.exit(0)

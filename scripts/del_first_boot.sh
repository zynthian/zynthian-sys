#!/bin/bash

#Delete "first_boot.sh" line from /etc/rc.local
sed -i -- "s/\/zynthian\/zynthian-sys\/scripts\/first_boot\.sh//" /etc/rc.local

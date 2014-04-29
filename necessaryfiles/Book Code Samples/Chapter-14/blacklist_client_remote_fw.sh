#!/bin/sh
/sbin/samtool -block -ip $remote_addr -dur 3600 \
yournetwork.firewall.com
echo "0"
exit

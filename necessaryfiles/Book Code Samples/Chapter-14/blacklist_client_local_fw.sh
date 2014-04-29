#!/bin/sh
/sbin/blacklist block $remote_addr 3600
echo "0"
exit

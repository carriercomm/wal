#!/bin/bash
# Recipe 1-2 Cryptographic Hash Tokens
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Script
 		cp /opt/modsecurity/etc/crs/confrules/hashtokens.conf /opt/modsecurity/etc/crs/rules/
        fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm /opt/modsecurity/etc/crs/rules/hashtokens.conf
		echo "# Rule is turned off" > /opt/modsecurity/etc/crs/rules/hashtokens.conf
	fi


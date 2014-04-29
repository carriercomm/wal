#!/bin/bash
# Recipe 1-2 Cryptographic Hash Tokens
#
# Syntax:
# hashtokens.sh <on/off>
#
# Example:
# hashtokens.sh on
# Requires Anonamally Scoring on
switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Cryptographic Hash Tokens
		cp /opt/modsecurity/etc/crs/confrules/hashtokens.conf /opt/modsecurity/etc/crs/rules/
        fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Cryptographic Hash Tokens
		rm /opt/modsecurity/etc/crs/rules/hashtokens.conf
		echo "# Rule is turned off" > /opt/modsecurity/etc/crs/rules/hashtokens.conf
	fi


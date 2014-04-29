#!/bin/bash
# IP Forensics Script 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On IP Forensics Violations Rule
 		cp $rulesconf/modsecurity_crs_61_ip_forensics.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_61_ip_forensics.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_61_ip_forensics.conf
		# service nginx restart
	fi


#!/bin/bash
# PVI Checks Script 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On PVI Checks Rule
 		cp $rulesconf/modsecurity_crs_56_pvi_checks.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_56_pvi_checks.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_56_pvi_checks.conf
		# service nginx restart
	fi


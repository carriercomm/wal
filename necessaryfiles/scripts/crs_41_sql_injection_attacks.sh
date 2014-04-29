#!/bin/bash
# SQL Injection Attacks On/Off Script
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On SQL Injection Attack Rule
 		cp $rulesconf/modsecurity_crs_41_sql_injection_attacks.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_41_sql_injection_attacks.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_41_sql_injection_attacks.conf
		# service nginx restart
	fi


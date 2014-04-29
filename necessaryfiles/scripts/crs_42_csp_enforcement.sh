#!/bin/bash
# CSP Enforcement Script 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

echo Not yet fuctional
exit 1
switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On CSP Enforcement Rule
 		cp $rulesconf/modsecurity_crs_42_csp_enforcement.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_42_csp_enforcement.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_42_csp_enforcement.conf
		# service nginx restart
	fi


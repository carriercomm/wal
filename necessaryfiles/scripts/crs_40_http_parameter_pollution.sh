#!/bin/bash
# HTTP Parameter Pollution Script 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On HTTP Parameter Pollution Rule
 		cp $rulesconf/modsecurity_crs_40_http_parameter_pollution.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_40_http_parameter_pollution.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_40_http_parameter_pollution.conf
		# service nginx restart
	fi


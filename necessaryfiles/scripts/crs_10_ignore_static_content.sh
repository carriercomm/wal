#!/bin/bash
# Rule 1-8 Ignore Static Content On/Off Script
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning Static Content Rule
 		cp $rulesconf/modsecurity_crs_10_ignore_static_content.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_10_ignore_static_content.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_10_ignore_static_content.conf
		# service nginx restart
	fi


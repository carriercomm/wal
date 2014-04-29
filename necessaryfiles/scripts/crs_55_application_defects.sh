#!/bin/bash
# Rule 2-1 PVI Option 2 Monitoring for Application Defects
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Passive Vulnerabily Identification 2 - Monitoring for Application Defects
 		cp $rulesconf/modsecurity_crs_55_application_defects.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_55_application_defects.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_55_application_defects.conf
		# service nginx restart
	fi


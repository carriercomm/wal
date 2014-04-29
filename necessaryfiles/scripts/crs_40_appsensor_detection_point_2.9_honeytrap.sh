#!/bin/bash
# Appsensor Detection Point Honeytrap On/Off Script
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Appsensor Detection Point Rule
 		cp $rulesconf/modsecurity_crs_40_appsensor_detection_point_2.9_honeytrap.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_40_appsensor_detection_point_2.9_honeytrap.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_40_appsensor_detection_point_2.9_honeytrap.conf
		# service nginx restart
	fi


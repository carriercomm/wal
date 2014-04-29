#!/bin/bash
# Appsensor Detection Point On/Off Script
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
 		cp $rulesconf/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf
		# service nginx restart
	fi


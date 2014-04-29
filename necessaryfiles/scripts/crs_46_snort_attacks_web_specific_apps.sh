#!/bin/bash
# Snort Ruleset Web Specific Apps 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Snort Attacks Web Specific Apps Ruleset
 		cp $rulesconf/modsecurity_crs_46_snort_attacks_web_specific_apps.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/crs_46_snort_attacks_web_specific_apps.sh
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_46_snort_attacks_web_specific_apps.conf
		# service nginx restart
	fi


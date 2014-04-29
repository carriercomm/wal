#!/bin/bash
# Snort Attack Web Server
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning Snort Attack Web Server Ruleset
 		cp $rulesconf/modsecurity_crs_46_snort_attacks_web_server.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_46_snort_attacks_web_server.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_46_snort_attacks_web_server.conf
		# service nginx restart
	fi


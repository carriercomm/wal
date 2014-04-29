#!/bin/bash
# Slow DoS Protection Rule On/Off Script
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

echo Not yet functional
exit 1
switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Protocol Violations Rule
 		cp $rulesconf/modsecurity_crs_11_slow_dos_protection.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_11_slow_dos_protection.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_11_slow_dos_protection.conf
		# service nginx restart
	fi


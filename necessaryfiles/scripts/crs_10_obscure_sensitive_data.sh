#!/bin/bash
# Obscure Sensitive Date Script 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Sensitive Data Obscuring Rul
 		cp $rulesconf/modsecurity_crs_10_obscure_sensitive_data.conf $rulesdir/
        	# service nginx restart
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_10_obscure_sensitive_data.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_10_obscure_sensitive_data.conf
		# service nginx restart
	fi


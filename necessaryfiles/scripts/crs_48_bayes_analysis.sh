#!/bin/bash
# Bayesian Analasys Script 
#
# Syntax:
# scriptname.sh <on/off>
#
# Example:
# scriptname.sh on

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo Turning On Bayesion Analysis Rule
 		cp $rulesconf/modsecurity_crs_48_bayes_analysis.conf $rulesdir/
        	moonrunner_init.sh
	fi

	if [ "$switch" = 'off' ]; then
		echo Turning Off Script
		rm $rulesdir/modsecurity_crs_48_bayes_analysis.conf
		echo "# Rule is turned off" > $rulesdir/modsecurity_crs_48_bayes_analysis.conf
		
	fi


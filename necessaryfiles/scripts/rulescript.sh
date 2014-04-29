#!/bin/bash
#Blank rule on/off script

switch=$1
test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	echo switch on
		echo line 2
        fi

	if [ "$switch" = 'off' ]; then
		echo switch off
	fi


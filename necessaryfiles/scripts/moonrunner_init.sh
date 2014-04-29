#!/bin/bash
#
# Moonrunner Init Script
#
spamfile=/opt/modsecurity/persistent/spam.cfc
if [ -f "$spamfile" ]
then
	echo \r
	echo "Moonrunner Initialization Script"
	echo "Moonrunner database file found, please run moonrunner_erase_db.sh then re-run script."
	exit 0
else
	/opt/modsecurity/etc/crs/lua/moonrunner.lua "classes /opt/modsecurity/persistent/spam /opt/modsecurity/persistent/ham" \
	"create" \
	"stats /opt/modsecurity/persistent/spam" \
	"stats /opt/modsecurity/persistent/ham" \
	"exit"
fi
exit

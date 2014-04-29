#!/bin/sh
/opt/local/bin/curl -s -b "$request_cookies" "http://192.168.1.110/
wordpress/wp-login.php?action=logout" > /dev/null
echo "0"
exit

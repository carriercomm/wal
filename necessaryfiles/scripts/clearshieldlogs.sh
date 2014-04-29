#!/bin/bash
# Script to clear ALL Shield logs
#
# NOTE: REQUIRES RESTART OF NGINX SERVER

cd /var/log/shield/
rm ./debug.log
rm ./modsec_audit.log
cd audit
rm -rf ./*


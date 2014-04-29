#!/bin/bash
#
# Erase moonrunner database files for bayesion analysis
#
echo Removing ham and spam db
rm /opt/modsecurity/persistent/spam.cfc
rm /opt/modsecurity/persistent/ham.cfc


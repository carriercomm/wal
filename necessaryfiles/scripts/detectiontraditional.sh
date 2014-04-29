#!/bin/bash
#
# Turns on Traditional Detection

echo Setting Traditional Detection Mode
cp $crsconfdir/modsecurity_crs_10_detectionmode.conf $crssetupdir/
cp $crsconfdir/modsecurity_crs_10_900001_collaborative_detection_levels.conf $crssetupdir/
cp $crsconfdir/modsecurity_crs_10_900002_900003_collaborative_detection_initialization.conf $crssetupdir/
cp $crsconfdir/modsecurity_crs_10_900004_collaborative_detection_blocking.conf $crssetupdir/
sed -i 's/blocking_var/'deny'/g' $crssetupdir/modsecurity_crs_10_detectionmode.conf


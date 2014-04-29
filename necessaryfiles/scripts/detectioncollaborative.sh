#!/bin/bash
#
# Turns on Collaborative Detection
#
# Usage detectioncollaborative.sh <blocking threshold>
#
# Example: detectioncollaborative.sh 5   (default)

blocking_threshold=$1
test $1 || exit 1

echo Setting Traditional Detection Mode
cp $crsconfdir/modsecurity_crs_10_detectionmode.conf $crssetupdir/
sed -i 's/blocking_var/'pass'/g' /$crssetupdir/modsecurity_crs_10_detectionmode.conf
cp $crsconfdir/modsecurity_crs_10_900001_collaborative_detection_levels_on.conf $crssetupdir/modsecurity_crs_10_900001_collaborative_detection_levels.conf
cp $crsconfdir/modsecurity_crs_10_900002_900003_collaborative_detection_initialization_on.conf $crssetupdir/modsecurity_crs_10_900002_900003_collaborative_detection_initialization.conf
sed -i 's/block_threshold_var/'$blocking_threshold'/g' $crssetupdir/modsecurity_crs_10_900002_900003_collaborative_detection_initialization.conf
cp $crsconfdir/modsecurity_crs_10_900004_collaborative_detection_blocking_on.conf $crssetupdir/modsecurity_crs_10_900004_collaborative_detection_blocking.conf
$scriptdir/crs_49_inbound_blocking.sh on
$scriptdir/crs_59_outbound_blocking.sh on
$scriptdir/crs_60_correlation.sh


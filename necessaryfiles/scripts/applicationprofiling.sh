#!/bin/bash
# Recipe 1-1 Real Time Application Profiling
#
# Syntax:
# applicationprofiling.sh <on/off> <min_pattern_threshold> <min_traffic_threshold>
#
# Def
# applicationprofiling.sh on 9 100

switch=$1
min_pattern_threshold=$2
min_traffic_threshold=$3

test $1 || exit 1

	if [ "$switch" = 'on' ]; then
        	test $2 || exit 1
		test $3 || exit 1
			echo Turning On Real Time Application Profiling
			cp /opt/modsecurity/etc/crs/confrules/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf /opt/modsecurity/etc/crs/rules/
			cp /opt/modsecurity/etc/crs/confrules/modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf /opt/modsecurity/etc/crs/rules/
			cp /opt/modsecurity/etc/crs/confrules/modsecurity_crs_40_appsensor_detection_point_3.0_end.conf /opt/modsecurity/etc/crs/rules/
			sed -i 's/min_pattern_threshold_var/'$min_pattern_threshold'/g' /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf
			echo Set Minimum Pattern Threshold Value to $min_pattern_threshold
			sed -i 's/min_traffic_threshold_var/'$min_traffic_threshold'/g' /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf
			echo Set Minimum Traffic Threshold Value to $min_traffic_threshold
        fi
		
	if [ "$switch" = 'off' ]; then
			echo Turning Off Real Time Application Profiling
			rm /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf 
			rm /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf 
			rm /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_3.0_end.conf 
			echo "# Rule is turned off" > /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf
			echo "# Rule is turned off" > /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf
			echo "# Rule is turned off" > /opt/modsecurity/etc/crs/rules/modsecurity_crs_40_appsensor_detection_point_3.0_end.conf
	fi

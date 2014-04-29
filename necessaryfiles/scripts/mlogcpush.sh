#!/bin/bash
#
# Pushes logs to AuditConsole via mlogc

/opt/modsecurity/bin/mlogc-batch-load.pl /var/log/shield/ /opt/modsecurity/bin/mlogc /opt/modsecurity/etc/conf/mlogc.conf

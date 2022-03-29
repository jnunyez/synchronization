#!/bin/bash
#get tsync conf file
GM_POD=`oc get pods | grep gm-1 | grep tsync | awk '{print $1}'`
oc exec -it $GM_POD -c du3-ldc1-tsync -- cat /etc/tsyncd/tsyncd.conf > ./conf/gm-tsyncd.conf

#get tsyncd.logs
oc exec -it $GM_POD -c du3-ldc1-tsync  -- cat /var/log/tsync_events.log > ./logs/gm-tsync_events.log
oc exec -it $GM_POD -c du3-ldc1-tsync  -- cat /var/log/tsyncd.log > ./logs/gm-tsyncd.log

#BOUNDARY CLOCK LOGS

BC_POD=`oc get pods | grep bc-1 | grep tsync | awk '{print $1}'`
oc exec -it $BC_POD -c du2-ldc1-tsync -- cat /etc/tsyncd/tsyncd.conf > ./conf/bc-tsyncd.conf

#get tsyncd.logs
oc exec -it $BC_POD -c du2-ldc1-tsync -- cat /var/log/tsync_events.log > ./logs/bc-tsync_events.log
oc exec -it $BC_POD -c du2-ldc1-tsync -- cat /var/log/tsyncd.log > ./logs/bc-tsyncd.log

#!/bin/bash

DATE=`date +"%Y_%m_%d_%I_%M_%p"`

# GM CLOCK LOGS
#get tsync conf file
GM_POD=`oc get pods | grep gm-1 | grep tsync | awk '{print $1}'`
oc exec -it $GM_POD -c du3-ldc1-tsync -- cat /etc/tsyncd/tsyncd.conf > ./conf/gm-tsyncd-$DATE.conf

#get tsyncd.logs
oc exec -it $GM_POD -c du3-ldc1-tsync  -- cat /var/log/tsync_events.log > ./logs/gm-tsync_events-$DATE.log
oc exec -it $GM_POD -c du3-ldc1-tsync  -- cat /var/log/tsyncd.log > ./logs/gm-tsyncd-$DATE.log

#BOUNDARY CLOCK LOGS

BC_POD=`oc get pods | grep $1-1 | grep tsync | awk '{print $1}'`
oc exec -it $BC_POD -c du2-ldc1-tsync -- cat /etc/tsyncd/tsyncd.conf > ./conf/$1-tsyncd-$DATE.conf

#get tsyncd.logs
oc exec -it $BC_POD -c du2-ldc1-tsync -- cat /var/log/tsync_events.log > ./logs/$1-tsync_events-$DATE.log
oc exec -it $BC_POD -c du2-ldc1-tsync -- cat /var/log/tsyncd.log > ./logs/$1-tsyncd-$DATE.log

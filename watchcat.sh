#!/bin/bash

#host to check
host='123.456.789.0'
port='443'

#timeouts = number of failed connections; interval = number of seconds to wait for new test
timeouts=9
interval=600

script="${0##*/}"
for pid in $(pidof -x $script); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : $script : Process is already running with PID $pid"
        exit 1
    fi
done

while true; do
        echo "Probing host: $host on port $port..."
        [[ `nc -w 2 -zv $host $port 2>&1 |grep -c succeeded` -eq 0 ]] && echo "Host is down" && away_counter=$((away_counter+1))
        echo $away_counter
        sleep $interval
        if [ $away_counter -eq $timeouts ]; then
                echo "Rebooting..."
                sudo /sbin/reboot
                exit 1
        fi
done

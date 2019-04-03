#!/bin/bash

#host to check
host='123.456.789.0'
port='443'

#method, either openssl or netcat. Openssl might be useful for https or for ip tunneling
method='openssl'

#timeouts = number of failed connections; interval = number of seconds to wait for new test
timeouts=9
interval=600

## do not edit below this line

script="${0##*/}"
for pid in $(pidof -x $script); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : $script : Process is already running with PID $pid"
        exit 1
    fi
done

declare -i away_counter=0

while true; do
        echo "Probing host: $host on port $port with method $method..."

        case $method in
                openssl)
                        [[ `openssl s_client -connect $host:$port 2>&1 |grep -c errno=104` -eq 1 ]] && echo "Host is down" && away_counter=$((away_counter+1))
                ;;
                netcat)
                        [[ `nc -w 2 -zv $host $port 2>&1 |grep -c succeeded` -eq 0 ]] && echo "Host is down" && away_counter=$((away_counter+1))
                ;;
        esac

        sleep $interval
        echo $away_counter
        if [ $away_counter == $timeouts ]; then
                echo "Rebooting..."
                sudo /sbin/reboot
                exit 1
        fi
done

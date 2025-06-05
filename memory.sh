#!/bin/sh

memTotal="$(grep MemTotal: /proc/meminfo | awk '{print $2}')"
memAvailable="$(grep MemAvailable: /proc/meminfo | awk '{print $2}')"
memUsed=$((memTotal - memAvailable))
memTotal=$(echo "scale=1; $memTotal / 1048576" | bc -l)
memUsed=$(echo "scale=1; $memUsed / 1048576" | bc -l)

printf "$memUsed/$memTotal GB"


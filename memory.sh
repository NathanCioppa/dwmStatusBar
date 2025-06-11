#!/bin/bash

tmpMemory="/tmp/statusBarMemory"
memTotal="$(grep MemTotal: /proc/meminfo | awk '{print $2}')"
memTotalRounded=$(echo "scale=1; $memTotal / 1048576" | bc -ls)

get_memory() {
	memAvailable="$(grep MemAvailable: /proc/meminfo | awk '{print $2}')"
	memUsed=$(echo "$memTotal - $memAvailable" | bc)
	memUsedRounded=$(echo "scale=1; $memUsed / 1048576" | bc -l)
	
	echo "$memUsedRounded/$memTotalRounded GB" > "$tmpMemory"
}


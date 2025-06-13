#!/bin/bash

tmpMemory="/tmp/statusBarMemory"
memTotal="$(grep MemTotal: /proc/meminfo | awk '{print $2}')"
memTotalRounded=$(echo "scale=1; $memTotal / 1048576" | bc -ls) #converted to Gigabytes

write_memory() {
	memAvailable="$(grep MemAvailable: /proc/meminfo | awk '{print $2}')"
	memUsed=$(echo "$memTotal - $memAvailable" | bc)
	memUsedRounded=$(echo "scale=1; $memUsed / 1048576" | bc -l) #converted to Gigabytes
	
	# only the memory being used needs to be written, since total memory is probably no changing durring runtime
	echo "$memUsedRounded" > "$tmpMemory"
}

get_memory() {
	memUsedRounded="$(cat "$tmpMemory")"
	echo "$memUsedRounded/$memTotalRounded GB"
}


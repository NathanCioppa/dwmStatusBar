#!/bin/bash

tmpMemory="/tmp/statusBarMemory"
memTotal="$(grep MemTotal: /proc/meminfo | awk '{print $2}')"
memTotal=$(echo "scale=1; $memTotal / 1048576" | bc -l)

get_memory() {
	memAvailable="$(grep MemAvailable: /proc/meminfo | awk '{print $2}')"
	memUsed=$((memTotal - memAvailable))
	memUsed=$(echo "scale=1; $memUsed / 1048576" | bc -l)
	
	printf "$memUsed/$memTotal GB" > "$tmpMemory"
}


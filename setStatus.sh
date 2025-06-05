#!/bin/sh

parentPID=$1
longestInterval=30
tick=0

DIR="$(cd "$(dirname "$0")" && pwd)"

memoryDelay=30
internetDelay=5
while kill -0 "$parentPID" 2>/dev/null; do
	if [ "$tick" -eq "$longestInterval" ]; then
		tick=0
	fi

	clock="$($DIR/time.sh)"

	if [ $(($tick % $memoryDelay)) -eq 0 ]; then
		memory="$($DIR/memory.sh)"
	fi

	if [ $(($tick % $internetDelay)) -eq 0 ]; then
		internet=$($DIR/internet.sh)
	fi

	xsetroot -name " RAM: $memory | $internet | $clock "

	tick=$((tick + 1))
	sleep 1
done

#!/bin/bash

tmpVolume="/tmp/statusBarVolume"

write_volume() {
	defaultSink="$(pactl get-default-sink)"
	# % symbol is EXCLUDED from being written to the file
	volumePercent="$(pactl get-sink-volume "$defaultSink" | grep "Volume:" | awk '{print $5}' | tr -d '%')"
	echo "$volumePercent" > "$tmpVolume"
}

get_volume() {
	volume=$(cat "$tmpVolume")
	tens=$((volume / 10))
	ones=$((volume % 10))

	fillToIndex=$((tens - 1))

	volumeDisplay=""
	if [ "$tens" -gt 10 ]; then
		tens=10
	fi
	for ((i = 0; i < tens; i++)); do
		volumeDisplay+="■"
	done
	if [ "$tens" -lt 10 ] && [ "$ones" -ge 5 ]; then
		volumeDisplay+="◆"
		tens=$((tens + 1))
	fi
	for ((i = tens; i < 10; i++)) do
		volumeDisplay+="~"
	done
	if [ "$volume" -lt 100]; then
		volume=" $volume"
	fi
	echo "$volumeDisplay $volume%"
}

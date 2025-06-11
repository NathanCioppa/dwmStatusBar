#!/bin/bash

tmpVolume="/tmp/statusBarVolume"

get_volume() {
	defaultSink="$(pactl get-default-sink)"
	volumePercent="$(pactl get-sink-volume "$defaultSink" | grep "Volume:" | awk '{print $5}')"
	printf "$volumePercent" > "$tmpVolume"
}

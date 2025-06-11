#!/bin/bash

tmpTemperature="/tmp/temperature"

get_temperature() {
	cpuTemp=$(($(cat /sys/class/thermal/thermal_zone1/temp) / 1000))
	
	if [[ $cpuTemp -ge 90 ]]; then
		warning=" **"
	elif [[ $cpuTemp -ge 70 ]]; then
		warning=" *"
	fi
	
	echo -e "$cpuTemp°C$warning" > "$tmpTemperature"
}

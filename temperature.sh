#!/bin/bash

cpuTemp=$(($(cat /sys/class/thermal/thermal_zone1/temp) / 1000))

get_temperature() {
	if [[ $cpuTemp -ge 90 ]]; then
		warning=" **"
	elif [[ $cpuTemp -ge 70 ]]; then
		warning=" *"
	fi
	
	echo -e "$cpuTemp°C$warning"
}

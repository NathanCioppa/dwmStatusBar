#!/bin/bash

tmpTemperature="/tmp/temperature"

write_temperature() {
	cpuTemp=$(($(cat /sys/class/thermal/thermal_zone1/temp) / 1000))
	# write temperature in degrees celcius
	echo "$cpuTemp" > "$tmpTemperature"
}

get_temperature() {
	cpuTemp="$(cat "$tmpTemperature")"	
	if [[ $cpuTemp -ge 90 ]]; then
		warning="**"
	elif [[ $cpuTemp -ge 70 ]]; then
		warning="*"
	else 
		warning=""
	fi
	
	echo "$cpuTemp°C$warning"
}

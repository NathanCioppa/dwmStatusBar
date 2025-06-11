#!/bin/bash

parentPID=$1
FIFO=/tmp/statusBarEvents
[ -p "$FIFO" ] || mkfifo "$FIFO"
DIR="$(cd "$(dirname "$0")" && pwd)"

tick=0
longestInterval=30
memoryDelay=30
internetDelay=5
temperatureDelay=5

source "$DIR/time.sh"
source "$DIR/internet.sh"
source "$DIR/temperature.sh"
source "$DIR/memory.sh"
source "$DIR/volume.sh"
get_volume
set_display() {
	clock="$(cat "$tmpTime")"
	memory="$(cat "$tmpMemory")"
	internet=$(cat "$tmpInternet")
	temperature=$(cat "$tmpTemperature")
	volume="$(cat "$tmpVolume")"

	xsetroot -name " CPU: $temperature | RAM: $memory | $internet | $volume | $clock "
}

event_listener() {
	"$DIR/audioMixerEvents.sh" "$FIFO" &
	while kill -0 "$parentPID" 2>/dev/null; do 
		read event < "$FIFO"
		case "$event" in 
			audioMixer) get_volume ;;
		esac
		set_display
	done
}

event_listener &

while kill -0 "$parentPID" 2>/dev/null; do
	if [ "$tick" -eq "$longestInterval" ]; then
		tick=0
	fi

	get_time

	if [ $(($tick % $memoryDelay)) -eq 0 ]; then
		get_memory
	fi

	if [ $(($tick % $internetDelay)) -eq 0 ]; then
		get_internet
	fi

	if [ $(($tick % temperatureDelay)) -eq 0 ]; then
		get_temperature
	fi

	set_display

	tick=$((tick + 1))
	sleep 1
done

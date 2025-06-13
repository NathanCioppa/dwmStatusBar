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
write_volume # initialize now, it wont be initialized by the loop

set_display() {
	clock="$(get_time)"
	memory="$(get_memory)"
	internet="$(get_internet)"
	temperature="$(get_temperature)"
	volume="$(get_volume)"

	xsetroot -name " $temperature | $memory | $volume | $internet | $clock "
}

event_listener() {
	"$DIR/audioEvents.sh" "$FIFO" &
	while kill -0 "$parentPID" 2>/dev/null; do
		read event < "$FIFO"
		case "$event" in 
			audioMixer) write_volume ;;
		esac
		set_display
	done
}

event_listener &

while kill -0 "$parentPID" 2>/dev/null; do
	if [ "$tick" -eq "$longestInterval" ]; then
		tick=0
	fi

	write_time

	if [ $(($tick % $memoryDelay)) -eq 0 ]; then
		write_memory
	fi

	if [ $(($tick % $internetDelay)) -eq 0 ]; then
		write_internet
	fi

	if [ $(($tick % temperatureDelay)) -eq 0 ]; then
		write_temperature
	fi

	set_display

	tick=$((tick + 1))
	sleep 1
done

#!/bin/sh

parentPID=$1
FIFO="/tmp/statusBarEvents"
	[ -p "$FIFO" ] || mkfifo "$FIFO"
DIR="$(cd "$(dirname "$0")" && pwd)"

tick=0
longestInterval=30
memoryDelay=30
internetDelay=5
temperatureDelay=5

set_display() {
	xsetroot -name " CPU: $temperature | RAM: $memory | $internet | $volume | $clock "
}

event_listener() {
	$DIR/audioMixerEvents.sh "$FIFO" &
	while kill -0 "$parentPID" 2>/dev/null; do 
		read event < "$FIFO"
		case "$event" in 
			audioMixer) volume="test" ;;
		esac
		set_display
	done
}

event_listener &

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

	if [ $(($tick % temperatureDelay)) -eq 0 ]; then
		temperature=$($DIR/temperature.sh)
	fi

	set_display

	tick=$((tick + 1))
	sleep 1
done

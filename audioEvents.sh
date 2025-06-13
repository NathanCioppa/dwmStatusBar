#!/bin/sh

FIFO="$1"
pactl subscribe | grep --line-buffered "sink" | while read -r _; do
	echo "audioMixer" > "$FIFO"
	sleep 0.05 # prevents rapid changes from freezing up the display
done

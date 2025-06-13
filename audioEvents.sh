#!/bin/sh

FIFO="$1"
pactl subscribe | grep --line-buffered "sink" | while read -r _; do
	echo "audioMixer" > "$FIFO"
done

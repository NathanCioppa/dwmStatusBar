#!/bin/sh

FIFO="$1"
echo $$ > errs
pactl subscribe | grep --line-buffered "sink" | while read -r _; do
	echo "here" >> errs
	echo "audioMixer" > "$FIFO"
done
echo "end" >> errs

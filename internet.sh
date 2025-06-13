#!/bin/bash

tmpInternet="/tmp/statusBarInternet"

internetUnit="dBm"
sigBest=65
sigGood=70
sigOk=80

write_internet() {
	#the whole string between spaces that shows signal level, starting with "level="
	signalLevelBlock=$(iwconfig | grep "Signal level" | awk '{print $4}')
	numStartIndex=$(expr index "$signalLevelBlock" "-")
	# signal level as a positive number
	signalLevel=${signalLevelBlock:numStartIndex}
	
	printf "$signalLevel" > "$tmpInternet"
}

get_internet() {
	signalLevel=$(cat "$tmpInternet")
	if [[ $signalLevel -le $sigBest ]]; then
		bars="▂▄▆█"
	elif [[ $signalLevel -le $sigGood ]]; then
		bars="▂▄▆_"
	elif [[ $signalLevel -le $sigOk ]]; then
		bars="▂▄__"
	else 
		bars="▂___"
	fi

	echo "$bars:$signalLevel$internetUnit"
}

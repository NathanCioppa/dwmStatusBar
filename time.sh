#!/bin/bash

tmpTime="/tmp/statusBarTime"
[[ -p "$tmpTime" ]] || mkfifo "$tmpTime"

get_time() {
	printf "$(date '+%-m/%-d %-l:%M%#p')" > "$tmpTime"
}

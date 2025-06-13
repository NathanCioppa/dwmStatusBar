#!/bin/bash

tmpTime="/tmp/statusBarTime"

write_time() {
	printf "$(date '+%-m/%-d %-l:%M%#p')" > "$tmpTime"
}

get_time() {
	echo "$(cat "$tmpTime")"
}

#!/bin/bash

tmpTime="/tmp/statusBarTime"

get_time() {
	printf "$(date '+%-m/%-d %-l:%M%#p')" > "$tmpTime"
}

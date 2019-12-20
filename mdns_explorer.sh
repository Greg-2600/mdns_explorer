#!/bin/bash
# search mdns cache for machines advertising ssh, vnc, and rdp

# most of the lessons to make this work came from:
# https://github.com/pstadler/non-terminating-bash-processes#conclusion

#services=$(grep tcp /etc/services|awk {'print $1'}|sort|uniq) # over 4000
services="ssh rfp ms-wbt-server"
 
for service in $services; do

	i=0

	while read -r line; do
		let i=$i+1

    		if [ $i -lt 5 ]; then 
			continue
		fi

		host=$(echo "$line"|grep "[A-Z]"|awk '{print $7".local"}')

		echo "$service $host"

    		if [ "$(echo "$line"|cut -d ' ' -f 3)" -ne '3' ]; then
        		break
    		fi

	done < <((sleep 0.5; 

	pgrep -q dns-sd && kill -13 "$(pgrep dns-sd)") & dns-sd -B _"$service"._tcp)
	pgrep -q dns-sd && kill -13 "$(pgrep dns-sd)"

done

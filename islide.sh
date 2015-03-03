#!/bin/bash

# Usage info
show_help() {
cat << EOF

EOF
}

# Variables
ip=""
f=""
pass=""
OPTIND=1
while getopts ":f:hi:p:" opt; do
	case "$opt" in 
		f)
			f=$OPTARG
			echo "-f $f"
			;;
		h)
			show_help
			exit 0
			;;
		i)
			ip=$OPTARG
			echo "-i was triggered, IP: $ip"
			;;
		p)
			pass=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			show_help
			exit 0
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 0
			;;
			
	esac
done
shift "$((OPTIND-1))"

if [ -n "$f" ] && [ -n "$ip" ]; then
	printf "Transferring app... " 
	set +v
	scp -r $f root@$ip:/Applications/
	set -v
	printf "done.\n"
	
	
else
	echo "-f and -i are required arguments"
	exit 0
fi
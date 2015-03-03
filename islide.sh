#!/bin/bash

# Usage info
show_help() {
cat << EOF

EOF
}

upload_app() {
	set +v
	echo `scp -r $a root@$ip:/Applications/`
	set -v
}

set_app() {
	local loc_app=""
	
	loc_app=${a:0: ${#a} - 5}
	
	ssh root@$ip '
	printf "Connecting...           done.\n"
		
	cd /var/mobile/
	chmod +x /Applications/$a/$loc_app
	printf "Setting permission...   done.\n"
		
	uicache
	printf "Clearing cache...       done.\n"
		
	killall -HUP SpringBoard
	printf "Respringing...          done.\n"
	exit 0
	exit 0
		'
}

uninstall() {
	ssh root@$ip '
	rm -rf /Applications/$u/
	printf "Uninstalling app...     done.\n"
	
	uicache
	printf "Clearing cache...       done.\n"
		
	killall -HUP SpringBoard
	printf "Respringing...          done.\n"
	exit 0
	'
}

# Variables
ip=""
a=""
u=""
OPTIND=1
while getopts ":a:hi:p:u:" opt; do
	case "$opt" in 
		a)
			a=$OPTARG
			echo "-a $a"
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
		u)
			u=$OPTARG
			echo "-u $u"
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

if [ -n "$a" ] && [ -n "$ip" ]; then
	
	
	printf "Transferring app... \n" 
	upload_app
	printf "Transferring app...     done.\n"
	
	#TODO: Integrity check
	
	printf "\nConnecting... "
	printf "Setting permission... "
	printf "Clearing cache... "
	printf "Respringing... "
	set_app

	exit 0 
elif [ -n "$u" ]; then 
	printf "\nUninstalling app..."
	printf "Clearing cache... "
	printf "Respringing... "
	uninstall
	
	exit 0
else
	echo "-a and -i are required arguments"
	exit 0
fi
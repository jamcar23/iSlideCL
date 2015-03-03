#!/bin/bash

# Usage info
help() {
cat << EOF
# Welcome to iSlideCL                      v0.1
# Copyright GPLv3 James Carroll (jamcar23) 2015
#
# Usuage: $(basename $0) [-ch] [-a appName.app] [-u appName.app] [-i IP Addrress]
# *You MUST have OpenSSH installed on your iDevice*
#
# commands:
#     -h    show this help text
#     -c    show copyright 
#     -a    App to be installed
#     -u    App to be uninstalled
#     -i    IP Address
EOF
}

copyright() {
cat << EOF
# Copyright James Carroll (jamcar23) 2015
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
EOF
}

upload_app() {
  printf "Transferring app... \n"
  set +v
  echo `scp -r $a root@$ip:/Applications/`
  set -v
  printf "Transferring app...     done.\n"
}

set_app() {
  local loc_app=""
	
  loc_app=${a:0: ${#a} - 5}

  printf "\nConnecting... "
  printf "Setting permission... "
  printf "Clearing cache... "
  printf "Respringing... "	
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
  '
}

uninstall() {
  printf "\nConnecting... "
  printf "Uninstalling app..."
  printf "Clearing cache... "
  printf "Respringing... "
  ssh root@$ip '
    printf "Connecting...           done.\n"

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

while getopts ":a:chi:p:u:" opt; do
  case "$opt" in 
    a)
      a=$OPTARG
      ;;
    c)
      copyright
      
      exit 0
      ;;
    h)
      help
      
      exit 0
      ;;
    i)
      ip=$OPTARG
      ;;
    p)
      pass=$OPTARG
      ;;
    u)
      u=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      help
      
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
  upload_app
  
  #TODO: Integrity check

  set_app
  
  exit 0 
elif [ -n "$u" ] && [ -n "$ip" ]; then 
  uninstall
  
  exit 0
else
  echo "-a and -i are required arguments"
  
  exit 0
fi
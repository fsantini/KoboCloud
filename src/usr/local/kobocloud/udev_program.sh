#!/bin/sh

if [ "$ACTION" != "add" ]; then
  exit 1
fi

#load config
. `dirname $0`/config.sh

#create work dirs
[ ! -e "$Logs" ] && mkdir -p "$Logs" >/dev/null 2>&1
[ ! -e "$Lib" ] && mkdir -p "$Lib" >/dev/null 2>&1
[ ! -e "$SD" ] && mkdir -p "$SD" >/dev/null 2>&1

#output to log
`dirname $0`/get.sh &> $Logs/get.log &

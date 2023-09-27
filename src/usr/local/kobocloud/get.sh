#!/bin/sh
#Kobocloud getter

TEST=$1

#load config
. $(dirname $0)/config.sh

#check if Kobocloud contains the line "UNINSTALL"
if grep -q '^UNINSTALL$' $UserConfig; then
    echo "Uninstalling KoboCloud!"
    $KC_HOME/uninstall.sh
    exit 0
fi

if grep -q "^REMOVE_DELETED$" $UserConfig; then
	echo "$Lib/filesList.log" > "$Lib/filesList.log"
fi


if [ "$TEST" = "" ]
then
    #check internet connection
    echo "`$Dt` waiting for internet connection"
    r=1;i=0
    while [ $r != 0 ]; do
    if [ $i -gt 60 ]; then
        ping -c 1 -w 3 aws.amazon.com >/dev/null 2>&1
        echo "`$Dt` error! no connection detected" 
        exit 1
    fi
    ping -c 1 -w 3 aws.amazon.com >/dev/null 2>&1
    r=$?
    if [ $r != 0 ]; then sleep 1; fi
    i=$(($i + 1))
    done
fi

# check for qbdb
if [ "$PLATFORM" = "Kobo" ]
then
  if [ -f "/usr/bin/qndb" ]
  then
      echo "NickelDBus found"
  else
      echo "NickelDBus not found: installing it!"
      $CURL -k -L "https://github.com/shermp/NickelDBus/releases/download/0.2.0/KoboRoot.tgz" | tar xz -C /
  fi
fi

while read url || [ -n "$url" ]; do
  echo "Syncing $url"
  if echo "$url" | grep -q '^#'; then
    echo "Comment found"
  elif echo "$url" | grep -q "^REMOVE_DELETED$"; then
	  echo "Will delete files no longer present on remote"
  else
    echo "Getting $url"    
    if grep -q "^REMOVE_DELETED$" $UserConfig; then    
      echo ${RCLONE} sync --config ${RCloneConfig} $url "$Lib"
      # Remove deleted, do a sync.
      ${RCLONE} sync --config ${RCloneConfig} $url "$Lib" 
    else
      echo ${RCLONE} copy --config ${RCloneConfig} $url "$Lib"
      # Don't remove deleted, do a copy.
      ${RCLONE} copy --config ${RCloneConfig} $url "$Lib"
    fi
  fi
done < $UserConfig

if [ "$TEST" = "" ]
then
    # Use NickelDBus for library refresh
    /usr/bin/qndb -t 3000 -s pfmDoneProcessing -m pfmRescanBooksFull
fi

rm "$Logs/index" >/dev/null 2>&1
echo "`$Dt` done"

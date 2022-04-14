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

while read url || [ -n "$url" ]; do
  echo "Reading $url"
  if echo "$url" | grep -q '^#'; then
    echo "Comment found"
  elif echo "$url" | grep -q "^REMOVE_DELETED$"; then
	echo "Will match remote"
  else
    echo "Getting $url"
    if echo $url | grep -q '^https*://www.dropbox.com'; then # dropbox link?
      $KC_HOME/getDropboxFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^DropboxApp:'; then # dropbox token
      auth=`echo $url | sed -e 's/^DropboxApp://' -e 's/[[:space:]]*$//'`
      client_id=`echo $auth | sed 's/:.*//'`
      refresh_token=`echo $auth | sed 's/.*://'`
      $KC_HOME/getDropboxAppFiles.sh "$client_id" "$refresh_token" "$Lib"
    elif echo $url | grep -q '^https*://filedn.com'; then
      $KC_HOME/getpCloudFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^https*://[^/]*pcloud'; then
      $KC_HOME/getpCloudFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^https*://drive.google.com'; then
      $KC_HOME/getGDriveFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^https*://app.box.com'; then
      $KC_HOME/getBoxFiles.sh "$url" "$Lib"
    else
      $KC_HOME/getOwncloudFiles.sh "$url" "$Lib"
    fi
  fi
done < $UserConfig

recursiveUpdateFiles() {
for item in *; do
	if [ -d "$item" ]; then 
		(cd -- "$item" && recursiveUpdateFiles)
	elif grep -Fq "$item" "$Lib/filesList.log"; then
		echo "$item found"
	else
		echo "$item not found, deleting"
		rm "$item"
	fi
done
}

if grep -q "^REMOVE_DELETED$" $UserConfig; then
	cd "$Lib"
	echo "Matching remote server"
	recursiveUpdateFiles
fi

if [ "$TEST" = "" ]
then
    #bind mount to subfolder of SD card (library refresh trick)
    mountpoint -q "$SD"
    if [ $? -ne 0 ]; then
    echo "`$Dt` bind mounting to SD"
    mount --bind "$Lib" "$SD"
    fi
    echo sd add /dev/mmcblk1p1 >> /tmp/nickel-hardware-status
fi

rm "$Logs/index" >/dev/null 2>&1
echo "`$Dt` done"

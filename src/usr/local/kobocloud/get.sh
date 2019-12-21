#!/bin/sh
#Kobocloud getter

#load config
. `dirname $0`/config.sh

#check if Kobocloud contains the line "UNINSTALL"
if grep -q '^UNINSTALL$' $UserConfig; then
    echo "Uninstalling KoboCloud!"
    `dirname $0`/uninstall.sh
    exit 0
fi

#check internet connection
echo "`$Dt` waiting for internet connection"
r=1;i=0
while [ $r != 0 ]; do
  if [ $i -gt 60 ]; then
    ping -c 1 -w 3 dropbox.com
    echo "`$Dt` error! no connection detected" 
    exit 1
  fi
  ping -c 1 -w 3 aws.amazon.com >/dev/null 2>&1
  r=$?
  if [ $r != 0 ]; then sleep 1; fi
  i=$(($i + 1))
done

while read url; do
  echo "Reading $url"
  if echo "$url" | grep -q '^#'; then
    echo "Comment found"
  else
    echo "Getting $url"
    if echo $url | grep -q '^https*://www.dropbox.com'; then # dropbox link?
      `dirname $0`/getDropboxFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^https*://filedn.com'; then
      `dirname $0`/getpCloudFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^https*://my.pcloud.com'; then
      `dirname $0`/getpCloudFiles.sh "$url" "$Lib"
    elif echo $url | grep -q '^https*://drive.google.com'; then
      `dirname $0`/getGDriveFiles.sh "$url" "$Lib"
    else
      `dirname $0`/getOwncloudFiles.sh "$url" "$Lib"
    fi
  fi
done < $UserConfig

#bind mount to subfolder of SD card (library refresh trick)
mountpoint -q "$SD"
if [ $? -ne 0 ]; then
  echo "`$Dt` bind mounting to SD"
  mount --bind "$Lib" "$SD"
fi
echo sd add /dev/mmcblk1p1 >> /tmp/nickel-hardware-status

rm "$Logs/index" >/dev/null 2>&1
echo "`$Dt` done"

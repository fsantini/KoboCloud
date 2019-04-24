#!/bin/sh

linkLine="$1"
localFile="$2"
user="$3"    

#load config
. `dirname $0`/config.sh


if [ "$user" = "" ]; then
    curlCommand=$CURL
else
    curlCommand="$CURL -u $user: "
fi
    
#echo $curlCommand
    
echo "$linkLine -> $localFile"

remoteSize=`$curlCommand -k -L --silent --head "$linkLine" | tr A-Z a-z | sed -n 's/^content-length\: \([0-9]*\).*/\1/p'`
echo "Remote size: $remoteSize"
if [ -f $localFile ]; then
  localSize=`stat -c%s "$localFile"`
else
  localSize=0
fi
if [ "$remoteSize" = "" ]; then
  remoteSize=1
fi
if [ $localSize -ge $remoteSize ]; then
  echo "File exists: skipping"
else
  $curlCommand -k --silent -C - -L -o "$localFile" "$linkLine" # try resuming
  if [ $? -ne 0 ]; then
    echo "Error resuming: redownload file"
    $curlCommand -k --silent -L -o "$localFile" "$linkLine" # restart download
  fi
fi
echo "getRemoteFile ended"

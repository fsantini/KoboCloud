#!/bin/sh

linkLine="$1"
localFile="$2"

#load config
source `dirname $0`/config.sh

echo "$linkLine -> $localFile"

remoteSize=`$CURL -k -L --silent --head "$linkLine" | sed -n 's/^Content-Length\: \([0-9]*\).*/\1/p'`
if [ -f $localFile ]; then
  localSize=`stat -c%s "$localFile"`
else
  localSize=0
fi
if [ $localSize -ge $remoteSize ]; then
  echo "File exists: skipping"
else
  $CURL -k --silent -C - -L -o "$localFile" "$linkLine" # try resuming
  if [ $? -ne 0 ]; then
    echo "Error resuming: redownload file"
    $CURL -k --silent -L -o "$localFile" "$linkLine" # restart download
  fi
fi
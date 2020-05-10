#!/bin/sh

linkLine="$1"
localFile="$2"
user="$3"
extra="$4"
remoteInfo="/tmp/.kobocloud-remote-file-info.txt"

#load config
. `dirname $0`/config.sh

curlCommand="$CURL"
if [ ! -z "$user" ] && [ "$user" != "-" ]; then
    echo "User: $user"
    curlCommand="$curlCommand -u $user: "
fi

if [ ! -z "$UserAgent" ]; then
    echo "Using custom userAgent: $UserAgent"
    curlCommand="$curlCommand -A '$UserAgent' "
fi

curlCommand="$curlCommand $CurlExtra "
if [ ! -z "$extra" ]; then
    echo "Adding extra curl arguments: $extra"
    curlCommand="$curlCommand $extra"
fi

curlHead="$curlCommand -k -L --silent --head $linkLine"
echo "Getting remote file information:"
echo "  Command: '$curlHead'"
$curlHead > $remoteInfo
echo "  Status: $?"

remoteSize=`cat $remoteInfo | tr A-Z a-z | sed -n 's/^content-length\: \([1-9]*\).*/\1/p'`
statusCode=`cat $remoteInfo | grep 'HTTP/' | tail -n 1 | cut -d' ' -f2`
echo "Remote file information:"
echo "  Remote size: $remoteSize"
echo "  Status code: $statusCode"
rm "$remoteInfo"

if echo "$statusCode" | grep -q "4.*"; then
    echo "Error: Forbidden"
    exit 2
fi
if echo "$statusCode" | grep -q "5.*"; then
    echo "Error: Server error"
    exit 3
fi

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

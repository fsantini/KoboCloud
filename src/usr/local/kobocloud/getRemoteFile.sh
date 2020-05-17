#!/bin/sh

linkLine="$1"
localFile="$2"
user="$3"
outputFileTmp="/tmp/kobo-remote-file-tmp.log"

#load config
. `dirname $0`/config.sh

curlCommand="$CURL"
if [ ! -z "$user" ] && [ "$user" != "-" ]; then
    echo "User: $user"
    curlCommand="$curlCommand -u $user: "
fi

echo "Download: "$curlCommand -k --silent -C - -L -o "$localFile" "$linkLine" -v

$curlCommand -k --silent -C - -L -o "$localFile" "$linkLine" -v 2>$outputFileTmp
status=$?
echo "Status: $status"
echo "Output: "
cat $outputFileTmp

statusCode=`cat $outputFileTmp | grep 'HTTP/' | tail -n 1 | cut -d' ' -f3`
rm $outputFileTmp

echo "Remote file information:"
echo "  Status code: $statusCode"

if echo "$statusCode" | grep -q "403"; then
    echo "Error: Forbidden"
    rm $localFile
    exit 2
fi
if echo "$statusCode" | grep -q "50.*"; then
    echo "Error: Server error"
    rm $localFile
    exit 3
fi

echo "getRemoteFile ended"

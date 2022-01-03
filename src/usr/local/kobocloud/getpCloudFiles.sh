#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

code=`echo $baseURL | sed 's/.*code=\([a-zA-Z0-9]*\).*/\1/'`

echo $code

# get directory listing
echo "Getting $baseURL"
# get directory listing
$CURL -k -L --silent "$baseURL" |
grep -Eo '"fileid": [0-9]+' |
sed 's/"fileid": \([0-9]*\)/\1/' | # find links
while read fileid
do
  echo $fileid
  
  # get public ID
  jsonAns=`$CURL -k -L --silent "https://api.pcloud.com/getpublinkdownload?code=$code&forcedownload=1&fileid=$fileid"`
  echo $jsonAns
  
  if echo $jsonAns | grep -q "error" # try European API
  then
    jsonAns=`$CURL -k -L --silent "https://eapi.pcloud.com/getpublinkdownload?code=$code&forcedownload=1&fileid=$fileid"`
    echo $jsonAns
  fi
  
  if echo $jsonAns | grep -q "error"
  then
    echo "Error downloading file"
    continue
  fi
  
  remotePath=`echo $jsonAns | sed -e 's/.*"path": "\([^"]*\)".*/\1/' -e 's@\\\\/@/@g'`
  #echo $remotePath
  outFileName=`echo $remotePath | sed 's@.*/\([^/]*\)@\1@'`
  #echo $outFileName
  host=`echo $jsonAns | sed 's/.*"hosts": \[ "\([^"]*\)".*/\1/'`
  #echo $host
  linkLine="https://$host$remotePath"
  #echo $linkLine
  
  # process line 
  localFile="$outDir/$outFileName"
  $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile"
  if [ $? -ne 0 ] ; then
      echo "Having problems contacting pCloud. Try again in a couple of minutes."
      exit
  fi
done

#!/bin/sh

baseURL="$1"
outDir="$2"
foundOldWay=false
#load config
. $(dirname $0)/config.sh

code=`echo $baseURL | sed 's/.*code=\([a-zA-Z0-9]*\).*/\1/'`

# get directory listing
#echo "Getting $baseURL"
echo "Using pCloud scraping, do not use subfolders, these might not be downloaded."
# get directory listing
$CURL -k -L --silent "$baseURL" |
grep -Eo '"fileid": [0-9]+' |
sed 's/"fileid": \([0-9]*\)/\1/' | # find links
while read fileid
do
  foundOldWay=true
  echo "FileID: "$fileid
  
  # get public ID
  jsonAns=`$CURL -k -L --silent "https://api.pcloud.com/getpublinkdownload?code=$code&forcedownload=1&fileid=$fileid"`
  echo "jsonAns1: "$jsonAns
  
  if echo $jsonAns | grep -q "error" # try European API
  then
    jsonAns=`$CURL -k -L --silent "https://eapi.pcloud.com/getpublinkdownload?code=$code&forcedownload=1&fileid=$fileid"`
    echo "jsonAns2: "$jsonAns
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
  # add the epub extension to kepub files
  if echo "$localFile" | grep -Eq '\.kepub$'
    then
      localFile="$localFile.epub"
  fi
  $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile"
  if [ $? -ne 0 ] ; then
      echo "Having problems contacting pCloud. Try again in a couple of minutes."
      exit
  fi
done

if [ "$foundOldWay" == false ] ; then
  echo "No files found using the old method, trying new method for pCloud."
  baseURLWithSlash=$baseURL
  baseURLWithSlash="${baseURLWithSlash%/}/"
  $CURL -k -L --silent "$baseURL" |
  ##get files with 3 or 4 characters extension
  grep -Eo '"name": .+",$' |
  ##Replace ,
  sed -E 's/"name": "(.+)",$/\1/' |
  while read name
    do
    if ! echo "$name" | grep -qE '.+\..{3,4}$'; then
      echo "Does not seem like a file so skipping: "$name
      continue
    fi
    echo "Processing: "$name
    linkLine=$baseURLWithSlash$name
    localFile="$outDir/$outFileName"
    $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile"
    outFileName=`echo $name | sed 's@.*/\([^/]*\)@\1@'`
    if [ $? -ne 0 ] ; then
      echo "Having problems contacting pCloud. Try again in a couple of minutes."
      exit
    fi
  done
fi
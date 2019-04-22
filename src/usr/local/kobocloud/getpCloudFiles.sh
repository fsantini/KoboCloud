#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. `dirname $0`/config.sh

# get directory listing
echo "Getting $baseURL"
# get directory listing
$CURL -k -L --silent "$baseURL" |
grep -Eo '"name": "[^"]+"' |
sed 's/"name": "\([^"]*\)"/\1/' | # find links
while read filename
do
  linkLine=$baseURL/`echo $filename | sed 's/ /%20/g'`
  linkLine=`echo $linkLine | tr -s '/'`
  outFileName=`echo $filename | tr ' ' '_'`
  echo $linkLine
  echo $outFileName
  # process line 
  #echo $outFileName
  localFile="$outDir/$outFileName"
  `dirname $0`/getRemoteFile.sh "$linkLine" "$localFile"
done

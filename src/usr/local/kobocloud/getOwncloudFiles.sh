#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
source `dirname $0`/config.sh

# get directory listing
$CURL -k -L --silent "$baseURL" | # get listing
grep '<a class="name" href=' | # find links
sed -e 's/.*href="\([^"]*\)".*/\1/' -e 's/&amp;/\&/g' | # extract links and replace ampersands
while read linkLine
do
  # process line 
  outFileName=`echo $linkLine | sed 's|.*path=/*\(.*\)|\1|'`
  localFile="$outDir/$outFileName"
  # get remote file
  `dirname $0`/getRemoteFile.sh "$linkLine" "$localFile"
done
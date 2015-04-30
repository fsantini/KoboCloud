#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
source `dirname $0`/config.sh

# get directory listing
echo "Getting $baseURL"
# get directory listing
$CURL -k -L --silent "$baseURL" | # get listing
grep -o '<a href="[^"]*"[^>]*class="thumb-link [^"]*">' | # find links
sed -e 's/.*href="\([^"]*\)".*/\1/' | # extract links and replace ampersands
while read linkLine
do
  # process line 
  outFileName=`echo $linkLine | sed -e 's|.*/\(.*\)?dl=.*|\1|'`
  localFile="$outDir/$outFileName"
  `dirname $0`/getRemoteFile.sh "$linkLine" "$localFile"
done

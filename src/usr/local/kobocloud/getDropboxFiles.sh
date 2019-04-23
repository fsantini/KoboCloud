#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. `dirname $0`/config.sh

baseURL=`echo "$baseURL" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`

# get directory listing
echo "Getting $baseURL"
# get directory listing
$CURL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" -k -L --silent "$baseURL" | # get listing. Need to specify a user agent, otherwise it will download the directory
grep -Eo 'previews\.dropboxusercontent\.com.*' | 
grep -Eo 'https?://www.dropbox.com/sh/[^\"]*' | # find links
while read linkLine
do
  if [ "$linkLine" = "$baseURL" ]
  then
    continue
  fi
  #echo $linkLine
  # process line 
  outFileName=`echo $linkLine | sed -e 's|.*/\(.*\)?dl=.*|\1|'`
  #echo $outFileName
  localFile="$outDir/$outFileName"
  `dirname $0`/getRemoteFile.sh "$linkLine" "$localFile"
done

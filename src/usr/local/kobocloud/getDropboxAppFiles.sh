#!/bin/sh

token="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

# get directory listing
response=$($CURL -k --silent -X POST https://api.dropboxapi.com/2/files/list_folder \
    --header "Authorization: Bearer $token" \
    --header "Content-Type: application/json" \
    --data '{"path": "","include_non_downloadable_files": false}')
echo "$response" |
sed -e 's/^.*\[{//' -e 's/}\].*$//' -e 's/}, {/\n/g' |
grep '".tag": "file"' | grep '"is_downloadable": true' |
while read item
do
  outFileName=`echo $item | sed 's/.*"name": "\([^"]*\)", ".*/\1/'`
  remotePath=`echo $item | sed 's/.*"path_lower": "\([^"]*\)", ".*/\1/'`
  localFile="$outDir/$outFileName"
  $KC_HOME/getRemoteFile.sh "https://content.dropboxapi.com/2/files/download" "$localFile" "$token" "$remotePath"
  if [ $? -ne 0 ] ; then
      echo "Having problems contacting Dropbox. Try again in a couple of minutes."
      exit
  fi
done

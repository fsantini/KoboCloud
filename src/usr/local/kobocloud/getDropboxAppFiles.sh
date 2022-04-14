#!/bin/sh

client_id="$1"
refresh_token="$2"
outDir="$3"

#load config
. $(dirname $0)/config.sh

token=`$CURL -k --silent https://api.dropbox.com/oauth2/token \
    -d grant_type=refresh_token \
    -d client_id=$client_id \
    -d refresh_token=$refresh_token |
    sed 's/.*"access_token": "\([^"]*\)", ".*/\1/'`

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

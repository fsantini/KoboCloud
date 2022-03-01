#!/bin/sh

token="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

# get directory listing
$CURL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" -k -L --silent "$baseURL" | # get listing. Need to specify a user agent, otherwise it will download the directory
grep -Eo 'ShmodelFolderEntriesPrefetch.*' | 
grep -Eo 'https?://www.dropbox.com/sh/[^\"]*' | # find links
sort -u | # remove duplicates

$CURL -k --silent -X POST https://api.dropboxapi.com/2/files/list_folder \
    --header "Authorization: Bearer $token" \
    --header "Content-Type: application/json" \
    --data '{"path": "","include_non_downloadable_files": false}' |
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

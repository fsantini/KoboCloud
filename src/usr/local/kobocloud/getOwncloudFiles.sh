#!/bin/sh
#function to percent-decode the filename from the OwnCloud URL
percentDecodeFileName() { printf "%b\n" "$(sed 's/+/ /g; s/%\([0-9a-f][0-9a-f]\)/\\x\1/g;')"; }

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

# webdav implementation
# https://myserver.com/s/shareLink
# or
# https://myserver.com/nextcloud/s/sharelink

shareID=`echo $baseURL | sed -e 's@.*s/\([^/ ]*\)$@\1@'`

# Extract the path.
path="$(echo $baseURL | grep / | cut -d/ -f4-)"
# Get the servername with path, used to get the file listing. (e.g. if the server uses domain.name/nextcloud, the nextcloud is kept as well.)
davServerWithOwncloudPath=`echo $baseURL | sed -e 's@.*\(http.*\)/s/[^/ ]*$@\1@' -e 's@/index\.php@@'`
# Remove the path to get the protocol and main domain only (used with the relative paths which are a result of "getOwncloudList.sh".)
davServer=$(echo $1 | sed -e s,/$path,,g)

echo "shareID: $shareID"
echo "davServer: $davServer"
echo "davServerWithOwncloudPath: $davServerWithOwncloudPath"

# get directory listing
$KC_HOME/getOwncloudList.sh $shareID $davServerWithOwncloudPath |
while read relativeLink
do
  # process line 
  outFileName=`echo $relativeLink | sed 's/.*public.php\/webdav\///' | percentDecodeFileName`
  linkLine=$davServer$relativeLink
  localFile="$outDir/$outFileName"
  # get remote file
  $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile" $shareID
  if [ $? -ne 0 ] ; then
      echo "Having problems contacting Owncloud. Try again in a couple of minutes."
      exit
  fi
done

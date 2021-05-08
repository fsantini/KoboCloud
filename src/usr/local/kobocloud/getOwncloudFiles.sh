#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

# webdav implementation
# https://myserver.com/s/shareLink

shareID=`echo $baseURL | sed -e 's@.*s/\([^/ ]*\)$@\1@'`
davServer=`echo $baseURL | sed -e 's@.*\(http.*\)/s/[^/ ]*$@\1@' -e 's@/index\.php@@'`

echo $shareID
echo $davServer

# get directory listing
$KC_HOME/getOwncloudList.sh $shareID $davServer |
while read relativeLink
do
  # process line 
  outFileName=`basename $relativeLink`
  linkLine=$davServer$relativeLink
  localFile="$outDir/$outFileName"
  # get remote file
  $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile" $shareID
  if [ $? -ne 0 ] ; then
      echo "Having problems contacting Owncloud. Try again in a couple of minutes."
      exit
  fi
done

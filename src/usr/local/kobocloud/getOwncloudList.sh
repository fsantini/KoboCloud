#!/bin/sh

user="$1"
davServer="$2"

#load config
. `dirname $0`/config.sh

echo '<?xml version="1.0"?>
<a:propfind xmlns:a="DAV:">
<a:prop><a:resourcetype/></a:prop>
</a:propfind>' |
$CURL -k --silent -i -X PROPFIND -u $user: $davServer/public.php/webdav --upload-file - -H "Depth: 1" | # get the listing
grep -Eo '<d:href>[^<]*[^/]</d:href>' | # get the links without the folders
sed 's@</*d:href>@@g' # remove the hrefs

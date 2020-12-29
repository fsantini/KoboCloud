#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

# get directory listing
echo "Getting $baseURL"
# get directory listing


#"type":"file","id":1917358802,"expirations":[],"canChangeExpiration":false,"tags":[],"description":"","date":1480871800,"extension":"pdf","name":"Carrapatoso, Eurico - Coral A.pdf"

gDirCode=`echo $baseURL | sed 's@.*/\(.*\)$@\1@'`

echo $gDirCode
$CURL -k -L --silent "$baseURL" |
grep -Po 'typedID":"[^"]+","type":"file","id":[0-9]+,(.+?),"name":"[^"]+"' | # find links
while read fileInfo
do
    echo "File info: $fileInfo"
    fileCode=`echo $fileInfo | sed -n 's/.*typedID":"\([^"]*\).*/\1/p'` # extract the code for file download (this is how a file is identified in Box)
    fileName=`echo $fileInfo | sed -n 's/.*"name":"\([^"]\+\)".*/\1/p'` # extract the file name
    echo "File code: $fileCode"
    echo "File name: $fileName"
    linkLine="https://app.box.com/index.php?rm=box_download_shared_file&shared_name=$gDirCode&file_id=$fileCode"
    outFileName=`echo $fileName | sed 's/\\u[0-9a-f]\{4\}/_/g' | tr ' ' '_'`
    localFile="$outDir/$outFileName"
    echo "Local file: $localFile"

    $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile"

    if [ $? -ne 0 ] ; then
        echo "Having problems contacting Box. Try again in a couple of minutes."
        exit
    fi
done

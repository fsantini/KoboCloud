#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. `dirname $0`/config.sh

# get directory listing
echo "Getting $baseURL"
# get directory listing

gDirCode=`echo $baseURL | sed 's@.*/\([^/\?]*\).*@\1@'`

echo $gDirCode

$CURL -k -L --silent "$baseURL" |
grep -Eo "\\\x5b\\\x22[^\\\]*\\\x22,\\\x5b\\\x22$gDirCode\\\x22\\\x5d\\\n,\\\x22[^\\\]*" | # find links
while read fileInfo
do
    echo $fileInfo
    fileCode=`echo $fileInfo | sed -n 's/x5bx22\([^\\\]*\)x22,.*/\1/p'` # extract the code for file download (this is how a file is identified in GDrive)
    fileName=`echo $fileInfo | sed -n 's/.*x22\(.*\)$/\1/p'` # extract the file name
    echo $fileCode
    echo $fileName
    linkLine="https://drive.google.com/uc?id=$fileCode&export=download"
    outFileName=`echo $fileName | tr ' ' '_'`
    localFile="$outDir/$outFileName"
    `dirname $0`/getRemoteFile.sh "$linkLine" "$localFile"
done

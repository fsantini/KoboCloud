#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

# get directory listing
echo "Getting $baseURL"
# get directory listing

gDirCode=`echo $baseURL | sed 's@.*/\([^/\?]*\).*@\1@'`

echo $gDirCode

links=`find_files "$gDirCode"` # find links
echo "$links" |
while read fileInfo
do
    echo "File info: $fileInfo"
    fileCode=`echo $fileInfo | sed -n 's/x5bx22\([^\\\]*\)x22,.*/\1/p'` # extract the code for file download (this is how a file is identified in GDrive)
    fileName=`echo $fileInfo | sed -n 's/.*x22\(.*\)$/\1/p'` # extract the file name
    echo "File code: $fileCode"
    echo "File name: $fileName"
    linkLine="https://drive.google.com/uc?id=$fileCode&export=download"
    outFileName=`echo $fileName | tr ' ' '_'`
    localFile="$outDir/$outFileName"

    $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile"
    if [ $? -ne 0 ] ; then
        echo "Having problems contacting Google Drive. Try again in a couple of minutes."
        exit
    fi
done

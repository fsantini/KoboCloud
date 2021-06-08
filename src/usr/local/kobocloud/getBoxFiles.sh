#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

currPage=1

# get directory listing
echo "Getting $baseURL"

boxDirCode=`echo $baseURL | sed 's@.*/\(.*\)$@\1@'`

pageContent=`$CURL -k -L --silent "$baseURL"`
numPages=`echo $pageContent | grep -Eo 'pageCount":[0-9]+,' | sed -n 's/pageCount":\([0-9]*\),/\1/p'`

while [ "$currPage" -le "$numPages" ]
do
    echo "$pageContent" | 
    grep -Eo 'typedID":"[^"]+","type":"file","id":[0-9]+,[^,]+,[^,]+,[^,]+,[^,]+,[^,]+,[^,]+,"name":"[^"]+"' | # find links
    while read fileInfo
    do
        #echo "File info: $fileInfo"
        fileCode=`echo $fileInfo | sed -n 's/.*typedID":"\([^"]*\).*/\1/p'` # extract the code for file download (this is how a file is identified in Box)
        fileName=`echo $fileInfo | sed -n 's/.*"name":"\([^"]\+\)".*/\1/p'` # extract the file name
        linkLine="https://app.box.com/index.php?rm=box_download_shared_file&shared_name=$boxDirCode&file_id=$fileCode"
        outFileName=`echo $fileName | sed 's/\\u[0-9a-f]\{4\}/_/g' | tr ' ' '_'`
        #echo $outFileName
        localFile="$outDir/$outFileName"
        $KC_HOME/getRemoteFile.sh "$linkLine" "$localFile"

        if [ $? -ne 0 ] ; then
            echo "Having problems contacting Box. Try again in a couple of minutes."
            exit
        fi
    done

    currPage=$((currPage + 1))
    if [ "$currPage" -le "$numPages" ] ; then
        echo "Fetching page $currPage from $baseURL?page=$currPage"
        pageContent=$($CURL -k -L --silent "$baseURL?page=$currPage")
    fi
    
done

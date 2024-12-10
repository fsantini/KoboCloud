#!/bin/sh

retry="TRUE"
curl_verbose="TRUE"

if [ "$1" = "NORETRY" ]
then
    retry="FALSE"
    shift 1
fi

if grep -q '^NO_CURL_VERBOSE$' $UserConfig; then
    curl_verbose="FALSE"
fi

linkLine="$1"
localFile="$2"
user="$3"
dropboxPath="$4"
outputFileTmp="/tmp/kobo-remote-file-tmp.log"

# add the epub extension to kepub files
if echo "$localFile" | grep -Eq '\.kepub$'
then
    localFile="$localFile.epub"
fi

#load config
. $(dirname $0)/config.sh

curlCommand="$CURL"
if [ ! -z "$user" ] && [ "$user" != "-" ]; then
    echo "User: $user"
    curlCommand="$curlCommand -u $user: "
fi

if [ ! -z "$dropboxPath" ] && [ "$dropboxPath" != "-" ]; then
    curlCommand="$CURL -X POST --header \"Authorization: Bearer $user\" --header \"Dropbox-API-Arg: {\\\"path\\\": \\\"$dropboxPath\\\"}\""
fi

echo "Download:" $curlCommand -k --silent -C - -L --create-dirs --remote-time -o \"$localFile\" \"$linkLine\" -v

eval $curlCommand -k --silent -C - -L --create-dirs --remote-time -o \"$localFile\" \"$linkLine\" -v 2>$outputFileTmp
status=$?
echo "Status: $status"

if [ "$curl_verbose" = "TRUE" ]
then
    echo "Output: "
    cat $outputFileTmp
fi

statusCode=`grep 'HTTP/' "$outputFileTmp" | tail -n 1 | cut -d' ' -f3`
grep -q "Cannot resume" "$outputFileTmp"
errorResume=$?
rm $outputFileTmp

echo "Remote file information:"
echo "  Status code: $statusCode"

if echo "$statusCode" | grep -q "403"; then
    echo "Error: Forbidden"
    exit 2
fi
if echo "$statusCode" | grep -q "50.*"; then
    echo "Error: Server error"
    if [ $errorResume ] && [ "$retry" = "TRUE" ]
    then
        echo "Can't resume. Checking size"
        contentLength=$(eval $curlCommand -k -sLI "$linkLine" | grep -i 'Content-Length' | sed 's/.*:\s*\([0-9]*\).*/\1/')
        existingLength=`stat --printf="%s" "$localFile"`
        echo "Remote length: $contentLength"
        echo "Local length: $existingLength"
        if [ $contentLength = 0 ] || [ $existingLength = $contentLength ]
        then
            echo "Not redownloading - Size not available or file already downloaded"
        else
            echo "Retrying download"
            rm "$localFile"
            $0 NORETRY "$@"
        fi
    else
        exit 3
    fi
fi

if grep -q "^REMOVE_DELETED" $UserConfig; then
	echo "$localFile" >> "$Lib/filesList.log"
	echo "Appended $localFile to filesList"
fi
echo "getRemoteFile ended"


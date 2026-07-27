#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

apiURL="https://cloud-api.yandex.net/v1/disk/public/resources"

parse_files() {
    local path="$1"
    
    local json=`$CURL -k -L --silent "$apiURL?public_key=$baseURL&path=$path"`
    
    # Parse all file download URLs  
    # grep: extracting "file": "..." from json
    # sed:  stripping the surrounding "file":" and trailing "
    local links=`echo $json | grep -o '"file":"[^"]*"' | sed 's/"file":"\(.*\)"/\1/'`
    for link in $links; do
        # sed: extracts the filename value out of query parameters by capturing everything between filename= and the next & (or end of string)    
        fileName=`echo "$link" | sed -n 's/.*filename=\([^&]*\).*/\1/p'`   
        if [ "$path" != "/" ]
        then
            fileName="$path/$fileName"
        fi
        $KC_HOME/getRemoteFile.sh "$link" "$outDir/$fileName"
        if [ $? -ne 0 ] ; then
            echo "Having problems contacting Yandex Disk. File: $fileName, URL: $link."
            exit
        fi
    done
    
    # Parse all subdirectories (expect root)
    # 1st grep: Extracts all matches of the pattern "path":"...","type":"dir" from the input, outputting each match on its own line (due to -o).
    # sed:      Strips away the surrounding "path":" and ","type":"dir" parts, keeping only the directory path (the content inside the quotes after "path":").
    # 2nd grep: Filters out (excludes) the line that exactly matches the value of the shell variable $path (with ^ and $ anchoring to start/end of line).
    local subdirs=`echo $json | grep -o '"path":"[^"]*","type":"dir"' | sed 's/"path":"\([^"]*\)","type":"dir"/\1/' | grep -v "^$path\$"`
    for subdir in $subdirs; do
        parse_files $subdir
    done
}

parse_files "/"

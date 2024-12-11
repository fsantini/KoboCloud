#!/bin/bash

SERVICE=$1
TEST_DELETED=$2
NO_CURL_VERBOSE=$3


TestFiles=("ulysses.epub" "01/ulysses.epub" "01/ulysses01.epub" "02/ulysses.epub" "02/ulysses02.epub")
sha1=d07c5da10d4666766d1b796ba420cffca0ac440c
TestSubdirs=false

if [ "$SERVICE" = "dropbox" ]
then
    URL='https://www.dropbox.com/sh/qql9j10qldxfvkx/AAB6Fl2AEL78gD27fUNfEgJQa'
elif [ "$SERVICE" = "pcloud" ]
then
    URL='https://u.pcloud.link/publink/show?code=kZBWSsXZPYXgN8YJtmjGSKNCQERxG80M2WiX'
    #URL='https://filedn.eu/lIJBHCuls5a4Nhjv5GJErfV'
elif [ "$SERVICE" = "box" ]
then
    URL='https://app.box.com/s/1y5e82xbyksuywamih7vu08yaiefqm65'
elif [ "$SERVICE" = "nextcloud" ]
then
    ##URL: domain.com/
    URL='https://nc01.adruna.org/s/XmtwFWBYxjNobGA'
elif [ "$SERVICE" = "nextcloudpath" ]
then
    ##URL: domain.com/nextcloud/
    URL='https://nc02.adruna.org/nextcloud/s/7zMe6kjyEHKr4TL'
elif [ "$SERVICE" = "nextcloudsubdir" ]
then
    ##URL: domain.com/
    ##Test scenario:
    ##main/
    # ├── 01/
    # │    ├── ulysses.epub
    # │    ├── ulysses01.epub
    # ├── 02/
    # │    ├── ulysses.epub
    # │    ├── ulysses02.epub
│   # ├── ulysses.epub
    URL='https://nc01.adruna.org/s/Y72RfYJM79jct8N'
    TestSubdirs=true
elif [ "$SERVICE" = "nextcloudsubdirpath" ]
then
    ##URL: domain.com/nextcloud
    ##Test scenario:
    ##main/
    # ├── 01/
    # │    ├── ulysses.epub
    # │    ├── ulysses01.epub
    # ├── 02/
    # │    ├── ulysses.epub
    # │    ├── ulysses02.epub
│   # ├── ulysses.epub
    URL='https://nc02.adruna.org/nextcloud/s/wsA7DSNjfYgBmw4'
    TestSubdirs=true
elif [ "$SERVICE" = "gdrive" ]
then
    URL='https://drive.google.com/drive/folders/1Wi37shmjG56L1D8OSdIZstkUfnpTsdAp'
    TestSubdirs=true
else
    echo "Unknown service"
    exit 1
fi

. src/usr/local/kobocloud/config_pc.sh

mkdir -p $Lib
for file in ${TestFiles[@]}
do
    rm "$Lib/$file"
done
echo $URL > $UserConfig

if [ "$TEST_DELETED" = true ]
then
    echo "Testing for deleted files"
    echo "REMOVE_DELETED" >> $UserConfig
    mkdir -p "$Lib/01"
    touch "$Lib/delete_me.epub"
    touch "$Lib/01/delete_me.epub"
fi
if [ "$NO_CURL_VERBOSE" = true ]
then
    echo "No verbose for curl"
    echo "NO_CURL_VERBOSE" >> $UserConfig
fi

src/usr/local/kobocloud/get.sh TEST

if [ "$TEST_DELETED" = true ]
then
    if [ -f "$Lib/delete_me.epub" ] || [ -f "$Lib/01/delete_me.epub" ]
    then
        echo "Files not deleted!"
        exit 1
    else
        echo "Files deleted successfully"
    fi
fi
        

for file in ${TestFiles[@]}
do
    echo "Testing $file"
    if sha1sum $Lib/$file | grep $sha1
    then
        echo OK
        if [ "$TestSubdirs" != true ] # if we only want to test one file, exit
        then
            exit 0
        fi
    else
        echo Failed
        exit 1
    fi
done

#relaunch sync to test when no change has to be made
src/usr/local/kobocloud/get.sh TEST

# if we reached here, we are good
exit 0

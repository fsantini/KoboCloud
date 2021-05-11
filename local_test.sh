#!/bin/bash

SERVICE=$1

TestFile=ulysses.epub
sha1=d07c5da10d4666766d1b796ba420cffca0ac440c

if [ "$SERVICE" = "dropbox" ]
then
    URL='https://www.dropbox.com/sh/qql9j10qldxfvkx/AAB6Fl2AEL78gD27fUNfEgJQa'
elif [ "$SERVICE" = "pcloud" ]
then
    URL='https://u.pcloud.link/publink/show?code=kZBWSsXZPYXgN8YJtmjGSKNCQERxG80M2WiX'
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
else
    URL='https://drive.google.com/drive/folders/1Wi37shmjG56L1D8OSdIZstkUfnpTsdAp'
fi

. src/usr/local/kobocloud/config_pc.sh

mkdir -p $Lib
rm -f $Lib/$TestFile
echo $URL > $UserConfig

src/usr/local/kobocloud/get.sh TEST

if sha1sum $Lib/$TestFile | grep $sha1
then
    echo OK
    exit 0
else
    echo Failed
    exit 1
fi

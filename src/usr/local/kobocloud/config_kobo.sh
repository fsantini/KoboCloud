#!/bin/sh
Logs=/mnt/onboard/.add/kobocloud
Lib=/mnt/onboard/.add/kobocloud/Library
SD=/mnt/sd/kobocloud
UserConfig=/mnt/onboard/.add/kobocloud/kobocloudrc
Dt="date +%Y-%m-%d_%H:%M:%S"
CURL="`dirname $0`/curl --cacert \"`dirname $0`/ca-bundle.crt\" "
UserAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
CurlExtra=""
GdriveCurlExtra="-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US;q=0.5,en;q=0.3' --compressed -H 'Connection: keep-alive'"

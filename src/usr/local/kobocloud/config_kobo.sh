#!/bin/sh
Logs=/mnt/onboard/.add/kobocloud
Lib=/mnt/onboard/.add/kobocloud/Library
SD=/mnt/sd/kobocloud
UserConfig=/mnt/onboard/.add/kobocloud/kobocloudrc
Dt="date +%Y-%m-%d_%H:%M:%S"
CURL="`dirname $0`/curl --cacert \"`dirname $0`/ca-bundle.crt\" "
UserAgent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"

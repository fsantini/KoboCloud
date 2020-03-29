#!/bin/sh
Logs=/mnt/onboard/.adds/kobocloud
Lib=/mnt/onboard/.adds/kobocloud/Library
SD=/mnt/sd/kobocloud
UserConfig=/mnt/onboard/.adds/kobocloud/kobocloudrc
Dt="date +%Y-%m-%d_%H:%M:%S"
CURL="`dirname $0`/curl --cacert \"`dirname $0`/ca-bundle.crt\" "

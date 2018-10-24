#!/bin/sh
Logs=/mnt/onboard/.kobo/kobocloud
Lib=/mnt/onboard/.kobo/kobocloud/Library
SD=/mnt/sd/kobocloud
UserConfig=/mnt/onboard/.kobo/kobocloud/kobocloudrc
Dt="date +%Y-%m-%d_%H:%M:%S"
CURL="`dirname $0`/curl --cacert \"`dirname $0`/ca-bundle.crt\" "

#!/bin/sh
Logs=/tmp/KoboCloud
Lib=/tmp/KoboCloud/Library
SD=/tmp/KoboCloud
UserConfig=/tmp/KoboCloud/kobocloudrc
Dt="date +%Y-%m-%d_%H:%M:%S"
CURL=/usr/bin/curl
UserAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
CurlExtra=""
GdriveCurlExtra="-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US;q=0.5,en;q=0.3' --compressed -H 'Connection: keep-alive'"

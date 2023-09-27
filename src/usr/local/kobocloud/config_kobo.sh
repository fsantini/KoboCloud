#!/bin/sh
Logs=/mnt/onboard/.add/kobocloud
Lib=/mnt/onboard/.add/kobocloud/Library
SD=/mnt/sd/kobocloud
UserConfig=/mnt/onboard/.add/kobocloud/kobocloudrc
RCloneConfig=/mnt/onboard/.add/kobocloud/rclone.conf
Dt="date +%Y-%m-%d_%H:%M:%S"
RCLONE="$KC_HOME/rclone --no-check-certificate "
PLATFORM=Kobo

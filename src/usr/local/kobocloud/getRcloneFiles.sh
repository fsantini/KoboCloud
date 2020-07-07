#!/bin/sh

baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh

rclone_config="/mnt/onboard/.add/kobocloud/kobo_rclone.conf"
RCLONE="$KC_HOME/rclone"

# Strip "RCLONE " from baseURL to get rclone path
baseURL=`echo ${baseURL} | sed 's/^[^ ]* //'`

# Rclone sync from baseURL (now RCLONE path) to outDir
${RCLONE} sync --config ${rclone_config} --no-check-certificate ${baseURL} ${outDir}

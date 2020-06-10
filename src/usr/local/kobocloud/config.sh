#!/bin/bash

ConfigFile=`dirname $0`/kobocloudrc.tmpl

if uname -a | grep -q x86
then
    #echo "PC detected"
    . `dirname $0`/config_pc.sh
else
    . `dirname $0`/config_kobo.sh
fi

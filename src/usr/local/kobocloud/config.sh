#!/bin/bash

KC_HOME=$(dirname $0)
ConfigFile=$KC_HOME/kobocloudrc.tmpl

if uname -a | grep -q x86
then
    #echo "PC detected"
    . $KC_HOME/config_pc.sh
else
    . $KC_HOME/config_kobo.sh
fi

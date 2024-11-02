#!/usr/bin/env bash

temp1=75
temp2=90

temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//'| sed 's/.0°C//')
temp=${temp%???}

ICON=""
if [ "$temp" -ge "$temp2" ] ; then
    echo "$ICON <fc=#C34043>$temp</fc>°C"
elif [ "$temp" -ge "$temp1" ] ; then
    echo "$ICON <fc=#DCA561>$temp</fc>°C"
else
    echo "$ICON <fc=#7E9CD8>$temp</fc>°C"
fi

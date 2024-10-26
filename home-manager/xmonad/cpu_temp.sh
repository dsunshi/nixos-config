#!/usr/bin/env bash

# TODO: colorscheme

temp1=75
temp2=90

temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//'| sed 's/.0°C//')
temp=${temp%???}

ICON=""
if [ "$temp" -ge "$temp2" ] ; then
    echo "$ICON <fc=#C1514E>$temp</fc>°C"
elif [ "$temp" -ge "$temp1" ] ; then
    echo "$ICON <fc=#C1A24E>$temp</fc>°C"
else
    echo "$ICON <fc=#AAC0F0>$temp</fc>°C"
fi

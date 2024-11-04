#!/usr/bin/env bash

temp1=75
temp2=90

temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//'| sed 's/.0°C//')
temp=${temp%???}

ICON="<fn=1></fn>"
if [ "$temp" -ge "$temp2" ] ; then
    echo "$ICON  <fc=#C34043>$temp</fc>°"
elif [ "$temp" -ge "$temp1" ] ; then
    echo "$ICON  <fc=#DCA561>$temp</fc>°"
else
    echo "$ICON  <fc=#7E9CD8>$temp</fc>°"
fi

#!/usr/bin/env bash

temp1=70
temp2=85

temp=$(nvidia-smi | grep 'Default' | awk '{print $3}' | sed 's/C//')
temp=${temp%???}

ICON="<fn=1>󰺵</fn>"
if [ "$temp" -ge "$temp2" ] ; then
    echo "$ICON   <fc=#C34043>$temp</fc>°"
elif [ "$temp" -ge "$temp1" ] ; then
    echo "$ICON   <fc=#DCA561>$temp</fc>°"
else
    echo "$ICON   <fc=#7E9CD8>$temp</fc>°"
fi

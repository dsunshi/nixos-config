#!/usr/bin/env bash

# TODO: colorscheme

temp1=70
temp2=85

temp=$(nvidia-smi | grep 'Default' | awk '{print $3}' | sed 's/C//')
temp=${temp%???}

ICON="<fn=1>󰺵</fn>"
if [ "$temp" -ge "$temp2" ] ; then
    echo "$ICON    <fc=#C1514E>$temp</fc>°C"
elif [ "$temp" -ge "$temp1" ] ; then
    echo "$ICON    <fc=#C1A24E>$temp</fc>°C"
else
    echo "$ICON    <fc=#AAC0F0>$temp</fc>°C"
fi

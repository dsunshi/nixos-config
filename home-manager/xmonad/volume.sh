#!/usr/bin/env bash

VOLUME=$(pamixer --get-volume)

OFF_ICON="<fn=1></fn>"
ON_ICON="<fn=1></fn>"
if [ "$VOLUME" -eq 0 ]; then
    echo "<fc=#C34043>$OFF_ICON</fc>"
else
    echo "$ON_ICON   $VOLUME%"
fi

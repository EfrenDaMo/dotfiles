#!/bin/bash

if [[ -z $(eww active-windows | grep 'media-center') ]]; then
    eww update medrev=true
    (sleep 0.2 && eww open media-center) &
else
    eww update medrev=false
    (sleep 0.2 && eww close media-center) &
fi

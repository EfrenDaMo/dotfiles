#!/bin/bash

if [[ -z $(eww active-windows | grep 'start-menu') ]]; then
    eww update menrev=true
    (sleep 0.2 && eww open start-menu) &
else
    eww update menrev=false
    (sleep 0.2 && eww close start-menu) &
fi


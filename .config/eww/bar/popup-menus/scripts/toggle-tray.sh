#!/bin/bash

if [[ -z $(eww active-windows | grep 'tray') ]]; then
    eww update trarev=true
    (sleep 0.5 && eww open tray) &
else
    eww update trarev=false
    (sleep 0.5 && eww close tray) &
fi

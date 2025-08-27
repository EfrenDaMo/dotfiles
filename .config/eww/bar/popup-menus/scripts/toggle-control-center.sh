#!/bin/bash

if [[ -z $(eww active-windows | grep 'control-center') ]]; then
    eww update conrev=true
    (sleep 0.2 && eww open control-center) &
else
    eww update conrev=false
    (sleep 0.2 && eww close control-center) &
fi

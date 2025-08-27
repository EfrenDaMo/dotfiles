#!/bin/bash

if [[ -z $(eww active-windows | grep 'calender') ]]; then
    eww update calrev=true
    (sleep 0.2 && eww open calender) &
else
    eww update calrev=false
    (sleep 0.2 && eww close calender) &
fi

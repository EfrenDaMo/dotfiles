#!/bin/bash

get_battery_info() {
    local battery_path=$(ls /sys/class/power_supply/BAT1/capacity 2>/dev/null | head -n1)

    if [ -z "$battery_path" ]; then
        echo "no_battery"
        return 
    fi

    local battery_dir=$(dirname "$battery_path")
    local capacity=$(cat "$battery_path")
    local status=$(cat "${battery_dir}/status")

    echo "$capacity $status"
}

get_battery_icon() {
    local info="$1"

    if [ "$info" = "no_battery" ]; then
        echo "󰚥"
        return 
    fi

    local capacity=$(echo "$info" | awk '{print $1}')
    local status=$(echo "$info" | awk '{print $2}')


    local icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
    local index=0

    if [ "$capacity" -ge 95 ]; then
        index=10
    elif ["$capacity" -ge 5 ]; then
        index=$((($capacity + 5) / 10))
    fi

    if [ "$status" = "Charging" ]; then
        echo "󰂄"
    else
        echo "${icons[$index]}"
    fi
}

get_battery_percent() {
    local info="$1"

    if [ "$info" = "no_battery" ]; then
        echo "AC"
        return 
    fi

    local capacity=$(echo "$info" | awk '{print $1}')
    local status=$(echo "$info" | awk '{print $2}')

    if [ "$status" = "Charging" ]; then
        echo " $capacity%"
    else
        echo "$capacity%"
    fi
}

get_battery_percentage() {
    local info="$1"

    if [ "$info" = "no_battery" ]; then
        echo 100
        return 
    fi

    echo $(echo "$info" | awk '{print $1}')
}

get_battery_status() {
    local info="$1"

    if [ "$info" = "no_battery" ]; then
        echo "AC"
        return 
    fi

    echo $(echo "$info" | awk '{print $2}')
}

ouput_battery_info() {
    local info="$1"
    local icon=$(get_battery_icon "$info")
    local percent=$(get_battery_percent "$info")
    local percentage=$(get_battery_percentage "$info")
    local status=$(get_battery_status "$info")

    echo "{\"icon\": \"$icon\", \"percent\": \"$percent\", \"percentage\": $percentage, \"status\": \"$status\"}"
}

main() {
    local battery_info=$(get_battery_info)

    case "$1" in
        "icon")
            get_battery_icon "$battery_info"
            ;;
        "percent")
            get_battery_percent "$battery_info"
            ;;
        "percentage")
            get_battery_percentage "$battery_info"
            ;;
        "status")
            get_battery_status "$battery_info"
            ;;
        "listen")
            local last_info="$battery_info"
            ouput_battery_info "$last_info"

            while true; do
                sleep 2
                local current_info=$(get_battery_info)
                if [ "$current_info" != "$last_info" ]; then
                    ouput_battery_info "$current_info"
                    last_info="$current_info"
                fi
            done
            ;;
        *)
            ouput_battery_info "$battery_info"
            ;;
    esac
}

main "$@"

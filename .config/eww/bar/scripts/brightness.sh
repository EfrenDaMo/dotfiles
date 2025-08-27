#!/bin/bash

get_brightness_info () {
    brightnessctl info | awk '
    /Current brightness:/ {
        # Extract the percentage from parentheses
        match($0, /\(([0-9]+)%\)/, arr)
        current = arr[1]
    }
    END {
        if (current != "") {
            print current
        }
    }'
}

get_brightness_icon() {
    local percent="$1"

    if [ "$percent" -lt 25 ]; then
        echo "󰃞"
    elif [ "$percent" -lt 50 ]; then
        echo "󰃟"
    elif [ "$percent" -lt 75 ]; then
        echo "󰃝"
    else
        echo "󰃠"
    fi
}

ouput_brightness_info() {
    local status="$1"
    local icon=$(get_brightness_icon "$status")
    local percent="$status"

    echo "{\"icon\": \"$icon\", \"percent\": $percent}"
}

main() {
    local brightness_status=$(get_brightness_info)

    case "$1" in
        "icon")
            get_brightness_icon "$brightness_status"
            ;;
        "percent")
            get_brightness_info "$brightness_status"
            ;;
        "listen")
            local last_status="$brightness_status"
            ouput_brightness_info "$last_status"

            while true; do
                sleep 0.1
                local current_status=$(get_brightness_info)

                if [ "$current_status" != "$last_status" ]; then
                    ouput_brightness_info "$current_status"
                    last_status="$current_status"
                fi
            done
            ;;
        *)
            ouput_brightness_info "$brightness_status"
            ;;
    esac

}

main "$@"

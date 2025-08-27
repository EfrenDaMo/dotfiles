#!/bin/bash

get_audio_info() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{
        if ($0 ~ /MUTED/) {
            print "muted"
        } else {
            volume = $2 * 100
            printf "%.0f\n", volume
        }
    }'
}

get_volume_icon() {
    local status="$1"

    if [ "$status" = "muted" ]; then
        echo "󰖁"
    else
        local volume="$status"
        if [ "$volume" -eq 0 ]; then
            echo "󰖁"
        elif [ "$volume" -lt 25 ]; then
            echo ""
        elif [ "$volume" -lt 50 ]; then
            echo ""
        elif [ "$volume" -lt 75 ]; then
            echo "󰕾"
        else
            echo ""
        fi
    fi
}

get_volume_percent() {
    local status="$1"

    if [ "$status" = "muted" ]; then
        echo "Muted"
    else
        echo "${status}%"
    fi
}

get_volume_percentage() {
    local status="$1"

    if [ "$status" = "muted" ]; then
        echo 0
    else
        echo "$status"
    fi
}

ouput_volume_info() {
    local status="$1"
    local icon=$(get_volume_icon "$status")
    local percent=$(get_volume_percent "$status")
    local percentage=$(get_volume_percentage "$status")

    echo "{\"icon\": \"$icon\", \"percent\": \"$percent\", \"percentage\": $percentage}"
}

main() {
    local audio_status=$(get_audio_info)

    case "$1" in
        "icon")
            get_volume_icon "$audio_status"
            ;;
        "percent")
            get_volume_percent "$audio_status"
            ;;
        "percentage")
            get_volume_percentage "$audio_status"
            ;;
        "listen")
            local last_status="$audio_status"
            ouput_volume_info "$last_status"

            while true; do
                sleep 0.1

                local current_status=$(get_audio_info)

                if [ "$current_status" != "$last_status" ]; then
                    ouput_volume_info "$current_status"
                    last_status="$current_status"
                fi
            done
            ;;
        *)
            ouput_volume_info "$audio_status"
            ;;
    esac
}

main "$@"

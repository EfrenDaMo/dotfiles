#!/bin/bash

get_player_status() {
    echo $(playerctl status 2>&1)
}

get_player_position() {
    local status="$1"

    if [ "$status" = "No players found" ]; then
        echo "--:--"
        return 
    fi

    echo $(playerctl position --format "{{ duration(position) }}")
}

get_player_progress() {
    local status="$1"

    if [ "$status" = "No players found" ]; then
        echo 0
        return 
    fi

    local max=$(playerctl metadata mpris:length)
    local position=$(playerctl position)

    if [ -z "$max" ] || [ -z "$position" ] || [ "$max" -eq 0 ]; then
        echo 0
        return
    fi

    local result=$(echo "scale=0; 100 * $position * 1000000 / $max" | bc -l)

    if [ "$result" -lt 0 ]; then
        result=0
    elif [ "$result" -gt 100 ]; then
        result=100
    fi

    echo $result
}

output_player_info() {
    local status="$1"
    local position=$(get_player_position "$status")
    local progress=$(get_player_progress "$status")

    echo "{\"position\": \"$position\", \"progress\": $progress}"
}


main() {
    local player_status=$(get_player_status)

    case "$1" in
        "position")
            get_player_position "$player_status"
            ;;
        "progress")
            get_player_progress "$player_status"
            ;;
        "listen")
            local last_status="$player_status"
            local last_info=$(output_player_info "$last_status")
            echo $last_info

            while true; do
                sleep .5
                local current_status=$(get_player_status)
                local current_info=$(output_player_info "$current_status")

                if [ "$current_info" != "$last_info" ]; then
                    echo "$current_info"
                    last_status="$current_status"
                    last_info="$current_info"
                fi
            done
            ;;
        *)
            output_player_info "$player_status"
            ;;
    esac
}

main "$@"

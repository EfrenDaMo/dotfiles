#!/bin/bash

get_media_status() {
    echo $(playerctl status 2>&1)
}

get_media_name() {
    local status="$1"

    if [ "$status" = "No players found" ]; then
        echo "-----"
        return 
    fi

    local fullname=$(playerctl metadata xesam:title 2>&1)
    local result="$fullname"

    # Remove anything after |
    result=$(echo "$result" | sed 's/ | .*//')

    # Remove anything in ()[]
    result=$(echo "$result" | sed 's/[[:space:]]*[([].*$//')

    # Remove artist names and other prefixes
    if [[ "$result" =~ ^[^-–]+[–-][[:space:]]*(.*) ]]; then
        result="${BASH_REMATCH[1]}"
    fi

    # Remove leading and trailing whitespace
    result=$(echo "$result" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    echo "$result"
}

get_media_artist() {
    local status="$1"

    if [ "$status" = "No players found" ]; then
        echo "-----"
        return 
    fi

    local fullname=$(playerctl metadata xesam:artist 2>&1)
    local result="$fullname"

    # Remove "- Topic" suffix
    result=$(echo "$result" | sed 's/[[:space:]]*-[[:space:]]*[Tt]opic[[:space:]]*$//')

    # Remove the VEVO suffix
    result=$(echo "$result" | sed 's/[[:space:]]*VEVO[[:space:]]*$//')
    result=$(echo "$result" | sed 's/VEVO$//')

    # Remove other suffixes
    result=$(echo "$result" | sed 's/[[:space:]]*-[[:space:]]*Official[[:space:]]*$//')
    result=$(echo "$result" | sed 's/[[:space:]]*Official[[:space:]]*$//')
    result=$(echo "$result" | sed 's/[[:space:]]*Records[[:space:]]*$//')
    result=$(echo "$result" | sed 's/[[:space:]]*Music[[:space:]]*$//')
    result=$(echo "$result" | sed 's/[[:space:]]*Entertainment[[:space:]]*$//')
    
    # Remove leading and trailing whitespace
    result=$(echo "$result" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # In case there are too many artist in the name
    if [[ -z "$result" ]] || [[ "$result" =~ ^(Various Artists?|Unknown|N/A)$ ]]; then
        result="$input"
    fi

    echo "$result"
}

get_media_label() {
    local status="$1"

    if [ "$status" = "No players found" ]; then
        echo "Not Playing 󰎇"
        return 
    fi

    local name=$(get_media_name)
    local artist=$(get_media_artist)

    if [ "$status" = "Playing" ]; then
        echo " $name - $artist 󰎇"
    else
        echo " $name - $artist 󰎇"
    fi
}


get_media_length() {
    local status="$1"

    if [ "$status" = "No players found" ]; then
        echo "--:--"
    else
        echo $(playerctl metadata --format "{{ duration(mpris:length) }}")
    fi
}

get_media_icon() {
    local status="$1"

    if [ "$status" = "Playing" ]; then
        echo ""
    else
        echo ""
    fi
}

get_media_art() {
    local status="$1"
    local user=$(whoami)
    local fallback_image="/home/$user/whitespace.jpg"

    if [ "$status" = "No players found" ]; then
        echo "$fallback_image"
        return 
    fi

    local art_url=$(playerctl metadata mpris:artUrl 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$art_url" ]; then
        echo "$fallback_image"
        return
    fi

    if [[ "$art_url" == file://* ]]; then
        echo "${art_url:7}"
    else
        echo "$art_url"
    fi
}

output_media_info() {
    local status="$1"
    local name=$(get_media_name "$status")
    local artist=$(get_media_artist "$status")
    local icon=$(get_media_icon "$status")
    local length=$(get_media_length "$status")
    local art=$(get_media_art "$status")
    local label=$(get_media_label "$status")

    echo "{\"status\": \"$status\", \"name\": \"$name\", \"artist\": \"$artist\", \"icon\": \"$icon\", \"length\": \"$length\", \"art\": \"$art\", \"label\": \"$label\"}"
}


main() {
    local media_status=$(get_media_status)

    case "$1" in
        "status")
            get_player_status "$media_status"
            ;;
        "name")
            get_media_name "$media_status"
            ;;
        "artist")
            get_media_artist "$media_status"
            ;;
        "icon")
            get_media_icon "$media_status"
            ;;
        "label")
            get_media_label "$media_status"
            ;;
        "length")
            get_media_length "$media_status"
            ;;
        "art")
            get_media_art "$media_status"
            ;;
        "listen")
            local last_status="$media_status"
            local last_info=$(output_media_info "$last_status")
            echo $last_info

            while true; do
                sleep .5
                local current_status=$(get_media_status)
                local current_info=$(output_media_info "$current_status")

                if [ "$current_info" != "$last_info" ]; then
                    echo "$current_info"
                    last_status="$current_status"
                    last_info="$current_info"
                fi
            done
            ;;
        *)
            output_media_info "$media_status"
            ;;
    esac
}

main "$@"

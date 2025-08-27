#!/bin/bash

get_network_state() {
    if ip link show | grep -E "enp" | grep -q "state UP"; then
        echo "ethernet"
        return 
    fi

    if iwgetid -r > /dev/null 2>&1; then
        echo "wifi"
        return
    fi

    if ip link show | grep -q "state UP"; then
        echo "linked"
        return 
    fi

    echo "disconnected"
}

get_network_strength() {
    local state="$1"
    if [ "$state" = "disconnected" ]; then
        echo "0"
    fi

    local strength=$(iwconfig 2>/dev/null | grep "Link Quality" | awk '{print $2}' | cut -d'=' -f2 | cut -d'/' -f1)
    if [ -z "$strength" ]; then
        echo "0"
    else
        echo "$strength"
    fi
} 

get_network_icon() {
    local state="$1"
    local icons=""
    
    if [ "$state" = "disconnected" ]; then
        echo ""
    fi

    case "$state" in
        "wifi")
            local strength=$(get_wifi_strength)
            if [ "$strength" -lt 20 ]; then
                echo "󰤯"
            elif [ "$strength" -lt 40 ]; then
                echo "󰤟"
            elif [ "$strength" -lt 60 ]; then
                echo "󰤢"
            elif [ "$strength" -lt 80 ]; then
                echo "󰤢"
            else
                echo "󰤨"
            fi
            ;;
        "ethernet")
            echo ""
            ;;
        "linked")
            echo ""
            ;;
        "disconnected")
            echo ""
            ;;
        *)
            echo ""
            ;;
    esac
}

get_network_name() {
    local state="$state"

    if [ "$state" = "ethernet" ]; then
        echo "Ethernet"
    else
        echo $(iwgetid -r) || echo "Unknown"
    fi
}

get_network_address() {
    local state="$1"

    if [ "$state" = "ethernet" ]; then
        echo $(ip add | grep enp | grep inet | awk '{print $2}'| awk '{print $1}' | cut -d'/' -f1)
    else
        echo $(ip add | grep wlan | grep inet | awk '{print $2}'| awk '{print $1}' | cut -d'/' -f1)
    fi
}

get_network_gateway() {
    local state="$1"

    if [ "$state" = "ethernet" ]; then
        echo $(ip route | grep default | grep enp | awk '{print $3}')
    else
        echo $(ip route | grep default | grep wlan | awk '{print $3}')
    fi
}

ouput_network_info() {
    local state="$1"
    local icon=$(get_network_icon "$state")
    local name=$(get_network_name "$state")
    local address=$(get_network_address "$state")
    local gateway=$(get_network_gateway "$state")

    echo "{\"state\": \"$state\", \"icon\": \"$icon\", \"name\": \"$name\", \"address\": \"$address\", \"gateway\": \"$gateway\"}"
}

main () {
    local network_state=$(get_network_state)

    case "$1" in
        "state")
            echo "$network_state"
            ;;
        "icon")
            get_network_icon "$network_state"
            ;;
        "name")
            get_network_name "$network_state"
            ;;
        "address")
            get_network_address "$network_state"
            ;;
        "gateway")
            get_network_gateway "$network_state"
            ;;
        "listen")
            local last_status="$network_state"
            ouput_network_info "$last_status"

            while true; do
                sleep 1
                local current_status=$(get_network_state)

                if [ "$current_status" != "$last_status" ]; then
                    ouput_network_info "$current_status"
                    last_status="$current_status"
                fi
            done
            ;;
        *)
            ouput_network_info "$network_state"
            ;;
    esac
}

main "$@"

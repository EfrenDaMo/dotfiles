#!/bin/bash

CACHE_FILE="/tmp/eww_network_cache"
CACHE_DIR="/tmp/eww_cpu_usage_cache"
mkdir -p "$CACHE_DIR"

# Get cpu stuff
get_cpu_frequency() {
    echo $(awk '/cpu MHz/ {printf "%.2f", $4 / 1000; exit}' /proc/cpuinfo)
}

get_cpu_percent() {
    echo $(top -bn1 | awk '/Cpu\(s\):/ {printf "%d", 100 - $8}')
}

get_cpu_core_usage() {
    local core=$1
    local cache_file="$CACHE_DIR/core_${core}"
    
    local stats=$(grep -E "^cpu${core}[[:space:]]" /proc/stat)
    if [ -z "$stats" ]; then
        echo "0"
        return
    fi
    
    local user=$(echo "$stats" | awk '{print ($2 != "") ? $2 : 0}')
    local nice=$(echo "$stats" | awk '{print ($3 != "") ? $3 : 0}')
    local system=$(echo "$stats" | awk '{print ($4 != "") ? $4 : 0}')
    local idle=$(echo "$stats" | awk '{print ($5 != "") ? $5 : 0}')
    local iowait=$(echo "$stats" | awk '{print ($6 != "") ? $6 : 0}')
    local irq=$(echo "$stats" | awk '{print ($7 != "") ? $7 : 0}')
    local softirq=$(echo "$stats" | awk '{print ($8 != "") ? $8 : 0}')
    local steal=$(echo "$stats" | awk '{print ($9 != "") ? $9 : 0}')
    local guest=$(echo "$stats" | awk '{print ($10 != "") ? $10 : 0}')
    local guest_nice=$(echo "$stats" | awk '{print ($11 != "") ? $11 : 0}')
    
    local total=$((user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice))
    local idle_total=$((idle + iowait))
    
    local now=$(date +%s.%N)
    
    if [ -f "$cache_file" ]; then
        read prev_total prev_idle prev_time < "$cache_file"
        
        local total_diff=$((total - prev_total))
        local idle_diff=$((idle_total - prev_idle))
        
        if [ $total_diff -gt 0 ]; then
            local usage=$(echo "scale=1; 100 * ($total_diff - $idle_diff) / $total_diff" | bc)
            
            if [ $(echo "$usage < 0" | bc) -eq 1 ]; then
                echo "0"
            elif [ $(echo "$usage > 100" | bc) -eq 1 ]; then
                echo "100"
            else
                echo "$usage"
            fi
        else
            echo "0"
        fi
    else
        echo "0"
    fi
    
    echo "$total $idle_total $now" > "$cache_file"
}

get_cpu_core_usage_data() {
    local core0=$(get_cpu_core_usage 0)
    local core1=$(get_cpu_core_usage 1)
    local core2=$(get_cpu_core_usage 2)
    local core3=$(get_cpu_core_usage 3)

    echo "{\"core0\": $core0, \"core1\": $core1, \"core2\": $core2, \"core3\": $core3}"
}

get_cpu_data() {
    local percent=$(get_cpu_percent)
    local frequency=$(get_cpu_frequency)
    local usage=$(get_cpu_core_usage_data)
    echo "{\"percent\": $percent, \"frequency\": \"$frequency GHz\", \"usage\": $usage}"
}

# Get ram stuff
get_ram_info() {
    awk '/MemTotal/ {total=$2} /MemAvailable/ {used=(total - $2)/1024/1024; printf "%.2f / %d GB", used, int((total/1024/1024)+0.5)}' /proc/meminfo
}

get_ram_usage() {
    get_ram_info | awk '{print $1}'
}

get_ram_max() {
    get_ram_info | awk '{print $3}'
}

get_ram_percent() {
    local usage=$(get_ram_usage)
    local max=$(get_ram_max)

    echo "($usage * 100) / $max" | bc
}

get_ram_data() {
    local usage=$(get_ram_usage)
    local max=$(get_ram_max)
    local percent=$(get_ram_percent)

    echo "{\"usage\": \"$usage\", \"max\": \"$max\", \"percent\": $percent}"
}

# Get temp stuff
get_temp() {
    local current=$((($(cat /sys/class/thermal/thermal_zone0/temp) / 1000 )))
    echo $current
}

get_temp_alt() {
    local ctemp=$(get_temp)
    local ftemp=$(echo "($ctemp * 9) / 5 + 32" | bc)
    echo "$ftemp"
}

get_temp_data() {
    local cel=$(get_temp)
    local far=$(get_temp_alt)

    echo "{\"celcius\": $cel, \"fahrenheit\": $far}"
}

# Network specific functions
get_bandwidth() {
    local interface=$(ip route show default | grep -oP 'dev \K\w+' | head -n1)
    if [ -z "$interface" ]; then 
        echo "0 0"
        return
    fi
    
    local stats=$(grep "^[[:space:]]*${interface}:" /proc/net/dev 2>/dev/null)
    if [ -z "$stats" ]; then
        echo "0 0"
        return
    fi
    
    local rx=$(echo "$stats" | awk '{print $2}')
    local tx=$(echo "$stats" | awk '{print $10}')
    local now=$(date +%s)
    
    if [ -f "$CACHE_FILE" ]; then
        read prev_rx prev_tx prev_time < "$CACHE_FILE"
        local diff=$((now - prev_time))
        if [ $diff -gt 0 ]; then
            local down_rate=$(( (rx - prev_rx) / diff ))
            local up_rate=$(( (tx - prev_tx) / diff ))
            if [ $down_rate -lt 0 ]; then
                down_rate=0
            fi
            if [ $up_rate -lt 0 ]; then
                up_rate=0
            fi
            echo "$down_rate $up_rate"
        else
            echo "0 0"
        fi
    else
        echo "0 0"
    fi
    
    echo "$rx $tx $now" > "$CACHE_FILE"
}

format_to_readable() {
    local bytes=$1

    if [ $bytes -lt 1024 ]; then
        echo "${bytes} B/s"
    elif [ $bytes -lt 1048576 ]; then
        echo "$(( bytes / 1024 )) KB/s"
    else
        echo "$(( bytes / 1048576 )) MB/s"
    fi
}

get_network_upspeed() {
    read down up < <(get_bandwidth)
    format_to_readable $up
}

get_network_downspeed() {
    read down up < <(get_bandwidth)
    format_to_readable $down
}

get_network_data() {
    local upload=$(get_network_upspeed)
    local download=$(get_network_downspeed)

    echo "{\"upload\": \"$upload\", \"download\": \"$download\"}"
}

output_system_info() {
    local cpu=$(get_cpu_data)
    local ram=$(get_ram_data)
    local temp=$(get_temp_data)
    local network=$(get_network_data)

    echo "{\"cpu\": $cpu, \"ram\": $ram, \"temp\": $temp, \"network\": $network}"
}

main() {
    case "$1" in
        "cpu")
            get_cpu_data
            ;;
        "ram")
            get_ram_data
            ;;
        "temp")
            get_temp
            ;;
        "network")
            get_network_data
            ;;
        "listen")
            local last_info=$(output_system_info)
            echo $last_info

            while true; do
                sleep 1

                local current_info=$(output_system_info)
                if [ "$last_info" != "$current_info" ]; then
                    echo $current_info
                    last_info="$current_info"
                fi
            done
            ;;
        *)
            output_system_info 
            ;;
    esac
}

main "$@"

#!/bin/bash

declare -A kanji_map=(
	[1]="一" [2]="二" [3]="三" [4]="四" [5]="五"
	[6]="六" [7]="七" [8]="八" [9]="九" [10]="十"
)

ws() {
    local output=""

    workspace_data=$(hyprctl workspaces -j)
    current_workspace=$(hyprctl  activeworkspace -j | jq -r '.id')

    mapfile -t all_ws_ids < <(echo "$workspace_data" | jq -r '.[].id' | sort -n)

    declare -A show_ws=()

    for wsid in "${all_ws_ids[@]}"; do
        windows=$(echo "$workspace_data" | jq -r --argjson id "$wsid" '[.[] | select(.id == $id)] | .[0]?.windows // 0')

        if [[ "$current_workspace" == "$wsid" || "$windows" -gt 0 ]]; then
            show_ws[$wsid]=1
        fi
    done

    mapfile -t ws_to_show < <(printf "%s\n" "${!show_ws[@]}" | sort -n)

    get_class() {
        local wsid=$1
        local windows=$2

        if [[ "$current_workspace" == "$wsid" ]]; then
            echo "workspace-active"
        elif [[ "$windows" -gt 0 ]]; then
            echo "workspace"
        else
            echo ""
        fi

    }

    for wsid in "${ws_to_show[@]}"; do
        if ((wsid < 0)); then
            continue 
        fi

        windows=$(echo "$workspace_data" | jq -r --argjson id "$wsid" '[.[] | select(.id == $id)] | .[0]?.windows // 0')

		if [[ "$wsid" -ge 1 && "$wsid" -le 10 ]]; then
			label="${kanji_map[$wsid]}"
		else
			label="$wsid"
		fi

        cls=$(get_class "$wsid" "$windows")

        if [[ -n "$cls" ]]; then
			output+="(eventbox :class \"workspace-e\" :cursor \"pointer\" :onclick \"hyprctl dispatch workspace $wsid\" (label :class \"$cls\" :text \"$label\"))"
		fi
    done

    echo "(box :halign 'start' :orientation 'h' $output)"
}

XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
HYPRLAND_SIGNATURE_ACTUAL=$(ls -td "$XDG_RUNTIME_DIR/hypr/"*/ 2>/dev/null | head -n1 | xargs -r basename)

if [[ -z "$HYPRLAND_SIGNATURE_ACTUAL" ]]; then
    echo "No Hyprland socket found. Exiting."
    exit 1
fi

SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_SIGNATURE_ACTUAL}/.socket2.sock"
ws

stdbuf -oL socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    case $line in
    "workspace>>"* | "createworkspace>>"* | "destroyworkspace>>"*)
        ws
        ;;
    esac
done

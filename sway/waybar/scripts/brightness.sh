#!/bin/bash

# Script de contrôle de la luminosité avec notifications Mako
# Usage: brightness.sh [up|down]

get_brightness() {
    brightnessctl get
}

get_max_brightness() {
    brightnessctl max
}

get_brightness_percent() {
    local current=$(get_brightness)
    local max=$(get_max_brightness)
    echo $((current * 100 / max))
}

send_notification() {
    local brightness=$(get_brightness_percent)
    
    # Choisir l'icône selon le niveau
    if [ "$brightness" -lt 20 ]; then
        icon="display-brightness-low"
    elif [ "$brightness" -lt 60 ]; then
        icon="display-brightness-medium"
    else
        icon="display-brightness-high"
    fi
    
    notify-send -a "brightness" -u normal -i "$icon" \
               -h string:x-canonical-private-synchronous:brightness \
               -h int:value:"$brightness" \
               "Brightness" "${brightness}%"
}

case $1 in
    up)
        brightnessctl set 5%+
        send_notification
        ;;
    down)
        brightnessctl set 5%-
        send_notification
        ;;
    *)
        echo "Usage: $0 [up|down]"
        exit 1
        ;;
esac
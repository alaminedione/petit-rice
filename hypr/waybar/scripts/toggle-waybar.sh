#!/bin/bash

# Script simple pour basculer l'affichage de Waybar
# Usage: toggle-waybar.sh

WAYBAR_CONFIG="$HOME/.config/hypr/waybar/config.json"
WAYBAR_STYLE="$HOME/.config/hypr/waybar/style.css"

if pgrep -x "waybar" > /dev/null; then
    # Waybar est en cours d'exécution, l'arrêter
    pkill waybar
    notify-send -a "waybar" -u normal -i "view-hidden" \
               "Waybar" "Masqué"
else
    # Waybar n'est pas en cours d'exécution, le démarrer
    waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" &
    notify-send -a "waybar" -u normal -i "view-visible" \
               "Waybar" "Affiché"
fi
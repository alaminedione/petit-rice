#!/bin/bash

# Script pour basculer l'affichage de Waybar
# Usage: toggle-waybar.sh

if pgrep -x "waybar" > /dev/null; then
    # Waybar est en cours d'exécution, l'arrêter
    pkill waybar
    notify-send -a "waybar" -u normal -i "view-hidden" \
               "Waybar" "Hidden"
else
    # Waybar n'est pas en cours d'exécution, le démarrer
    waybar -c ~/.config/waybar/config-sway -s ~/.config/waybar/style.css &
    notify-send -a "waybar" -u normal -i "view-visible" \
               "Waybar" "Visible"
fi
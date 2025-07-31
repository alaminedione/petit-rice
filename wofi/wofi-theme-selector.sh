#!/bin/bash

THEME_DIR="$HOME/.config/petit-rice-scripts/change-theme/"

if [ ! -d "$THEME_DIR" ]; then
    notify-send "Error" "Theme directory '$THEME_DIR' not found."
    exit 1
fi

# Générer la liste des thèmes à partir des noms de fichiers (set-THEME.sh)
themes=$(ls "$THEME_DIR" | grep '^set-.*\.sh$' | sed -e 's/^set-//' -e 's/\.sh$//')

# Afficher le menu wofi et récupérer la sélection
selected_theme=$(echo "$themes" | wofi --dmenu --prompt "Select a theme")

# Si un thème est sélectionné, exécuter le script correspondant
if [ -n "$selected_theme" ]; then
    script_path="$THEME_DIR/set-$selected_theme.sh"
    if [ -f "$script_path" ]; then
        sh "$script_path"
        notify-send "Theme Changed" "Theme '$selected_theme' has been applied."
    else
        notify-send "Error" "Script for theme '$selected_theme' not found."
    fi
fi

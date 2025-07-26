#!/bin/bash

# Script de capture d'écran avec grim et slurp - Thème Catppuccin Mocha
# Compatible avec Sway et Wayland

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

case $1 in
    full)
        # Capture d'écran complète
        filename="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        grim "$filename"
        notify-send -a "screenshot" -u normal -i "camera-photo" \
            "Screenshot" \
            "Full screen saved to\n$(basename "$filename")"
        ;;
    area)
        # Capture d'écran d'une zone sélectionnée
        filename="$SCREENSHOT_DIR/screenshot-area-$(date +%Y%m%d-%H%M%S).png"
        grim -g "$(slurp -d)" "$filename"
        if [ $? -eq 0 ]; then
            notify-send -a "screenshot" -u normal -i "camera-photo" \
                "Screenshot" \
                "Selected area saved to\n$(basename "$filename")"
        fi
        ;;
    clipboard)
        # Capture d'écran dans le presse-papiers
        grim -g "$(slurp -d)" - | wl-copy
        if [ $? -eq 0 ]; then
            notify-send -a "screenshot" -u normal -i "camera-photo" \
                "Screenshot" \
                "Area copied to clipboard"
        fi
        ;;
    window)
        # Capture d'écran de la fenêtre active
        filename="$SCREENSHOT_DIR/screenshot-window-$(date +%Y%m%d-%H%M%S).png"
        # Obtenir les coordonnées de la fenêtre active
        window_geometry=$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
        grim -g "$window_geometry" "$filename"
        notify-send -a "screenshot" -u normal -i "camera-photo" \
            "Screenshot" \
            "Active window saved to\n$(basename "$filename")"
        ;;
    *)
        echo "Usage: $0 {full|area|clipboard|window}"
        echo "  full      - Full screen capture"
        echo "  area      - Selected area capture"
        echo "  clipboard - Capture to clipboard"
        echo "  window    - Active window capture"
        exit 1
        ;;
esac
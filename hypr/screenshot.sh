#!/bin/bash

# Screenshot script with grim and slurp - Catppuccin Mocha theme
# Compatible with Sway and Wayland

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

case $1 in
    full)
        # Full screen capture
        filename="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        grim "$filename"
        notify-send -a "screenshot" -u normal -i "camera-photo" \
            "Screenshot" \
            "Full screen saved to\n$(basename "$filename")"
        ;;
    area)
        # Selected area capture
        filename="$SCREENSHOT_DIR/screenshot-area-$(date +%Y%m%d-%H%M%S).png"
        grim -g "$(slurp -d)" "$filename"
        if [ $? -eq 0 ]; then
            notify-send -a "screenshot" -u normal -i "camera-photo" \
                "Screenshot" \
                "Selected area saved to\n$(basename "$filename")"
        fi
        ;;
    clipboard)
        # Capture to clipboard
        grim -g "$(slurp -d)" - | wl-copy
        if [ $? -eq 0 ]; then
            notify-send -a "screenshot" -u normal -i "camera-photo" \
                "Screenshot" \
                "Area copied to clipboard"
        fi
        ;;
    window)
        # Active window capture
        filename="$SCREENSHOT_DIR/screenshot-window-$(date +%Y%m%d-%H%M%S).png"
        # Get active window coordinates
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

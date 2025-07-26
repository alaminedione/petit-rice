#!/bin/bash

# Wofi Launcher Script avec thème Catppuccin Mocha
# Usage: wofi-launcher.sh [drun|run|window|emoji|power]

CONFIG="$HOME/.config/wofi/config"
STYLE="$HOME/.config/wofi/style.css"
COLORS="$HOME/.config/wofi/colors"

# Couleurs Catppuccin Mocha
ROSEWATER="f5e0dc"
FLAMINGO="f2cdcd"
PINK="f5c2e7"
MAUVE="cba6f7"
RED="f38ba8"
MAROON="eba0ac"
PEACH="fab387"
YELLOW="f9e2af"
GREEN="a6e3a1"
TEAL="94e2d5"
SKY="89dceb"
SAPPHIRE="74c7ec"
BLUE="89b4fa"
LAVENDER="b4befe"
TEXT="cdd6f4"
SUBTEXT1="bac2de"
SUBTEXT0="a6adc8"
OVERLAY2="9399b2"
OVERLAY1="7f849c"
OVERLAY0="6c7086"
SURFACE2="585b70"
SURFACE1="45475a"
SURFACE0="313244"
BASE="1e1e2e"
MANTLE="181825"
CRUST="11111b"

case $1 in
    drun)
        wofi --show drun \
             --conf "${CONFIG}" \
             --style "${STYLE}" \
             --term='foot' \
             --prompt='Applications' \
             --insensitive
        ;;
    run)
        wofi --show run \
             --conf "${CONFIG}" \
             --style "${STYLE}" \
             --term='foot' \
             --prompt='Run Command' \
             --insensitive
        ;;
    window)
        window=$(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.type=="workspace") | .nodes[] | select(.type=="con") | "\(.id): \(.name)"' | \
                 wofi --show dmenu \
                      --conf "${CONFIG}" \
                      --style "${STYLE}" \
                      --prompt='Windows' \
                      --insensitive)
        
        if [ -n "$window" ]; then
            window_id=$(echo "$window" | cut -d: -f1)
            swaymsg "[con_id=$window_id] focus"
        fi
        ;;
    emoji)
        wofi --show dmenu \
             --conf "${CONFIG}" \
             --style "${STYLE}" \
             --prompt='Emoji' \
             --insensitive < ~/.config/wofi/emoji.txt | \
             wl-copy
        ;;
    power)
        chosen=$(echo -e "🔒 Lock\n🚪 Logout\n💤 Suspend\n🔄 Reboot\n⏻ Shutdown" | \
                 wofi --show dmenu \
                      --conf "${CONFIG}" \
                      --style "${STYLE}" \
                      --prompt='Power Menu' \
                      --insensitive)
        
        case $chosen in
            "🔒 Lock")
                ~/.config/swaylock/swaylock.sh
                ;;
            "🚪 Logout")
                swaymsg exit
                ;;
            "💤 Suspend ")
                systemctl suspend
                ;;
            "🔄 Reboot")
                systemctl reboot
                ;;
            " ⏻ Shutdown")
                shutdown now
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 [drun|run|window|emoji|power]"
        echo "  drun    - Application launcher"
        echo "  run     - Command runner"
        echo "  window  - Window switcher"
        echo "  emoji   - Emoji picker"
        echo "  power   - Power menu"
        ;;
esac

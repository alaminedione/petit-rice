
#!/bin/bash
# Wofi Launcher Script avec thème Catppuccin Mocha
# Compatible avec Sway et Hyprland
# Usage: wofi-launcher.sh [drun|run|window|emoji|power]

CONFIG="$HOME/.config/wofi/config"
STYLE="$HOME/.config/wofi/style.css"

# Détection automatique du window manager
detect_wm() {
    if [ -n "$SWAYSOCK" ]; then
        echo "sway"
    elif [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "hyprland"
    elif pgrep -x "sway" > /dev/null; then
        echo "sway"
    elif pgrep -x "Hyprland" > /dev/null; then
        echo "hyprland"
    else
        echo "unknown"
    fi
}

WM=$(detect_wm)

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
        case $WM in
            sway)
                window=$(swaymsg -t get_tree | jq -r '
                    .nodes[].nodes[] 
                    | select(.type=="workspace") 
                    | .nodes[] 
                    | select(.type=="con") 
                    | "\(.id): \(.name)"' | \
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
            hyprland)
                window=$(hyprctl clients -j | jq -r '.[] | "\(.address): \(.title)"' | \
                         wofi --show dmenu \
                              --conf "${CONFIG}" \
                              --style "${STYLE}" \
                              --prompt='Windows' \
                              --insensitive)
                
                if [ -n "$window" ]; then
                    window_address=$(echo "$window" | cut -d: -f1)
                    hyprctl dispatch focuswindow "address:$window_address"
                fi
                ;;
            *)
                echo "Window manager non supporté ou non détecté"
                exit 1
                ;;
        esac
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
                case $WM in
                    sway)
                        if [ -f ~/.config/swaylock/swaylock.sh ]; then
                            ~/.config/swaylock/swaylock.sh
                        else
                            swaylock
                        fi
                        ;;
                    hyprland)
                        if command -v hyprlock > /dev/null; then
                            hyprlock
                        elif command -v swaylock > /dev/null; then
                            swaylock
                        else
                            echo "Aucun écran de verrouillage trouvé"
                        fi
                        ;;
                esac
                ;;
            "🚪 Logout")
                case $WM in
                    sway)
                        swaymsg exit
                        ;;
                    hyprland)
                        hyprctl dispatch exit
                        ;;
                esac
                ;;
            "💤 Suspend")
                systemctl suspend
                ;;
            "🔄 Reboot")
                if command -v systemctl > /dev/null; then
                    systemctl reboot
                else
                    echo "Commande reboot non trouvée"
                fi
                ;;
            "⏻ Shutdown")
                if command -v systemctl > /dev/null; then
                    systemctl poweroff
                else
                    echo "Commande shutdown non trouvée"
                fi
                ;;
            *)
                echo "Option non reconnue"
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 [drun|run|window|emoji|power]"
        echo "  drun    - Application launcher"
        echo "  run     - Command runner"
        echo "  window  - Window switcher (compatible Sway/Hyprland)"
        echo "  emoji   - Emoji picker"
        echo "  power   - Power menu (compatible Sway/Hyprland)"
        echo ""
        echo "Window Manager détecté: $WM"
        ;;
esac


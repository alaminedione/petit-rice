#!/bin/bash

# Script de contrôle du volume amélioré avec notifications Mako
# Auteur: Amélioré par Forge
# Version: 2.0
# Usage: volume.sh [up|down|mute|mic-mute|show|set <value>] [step]

# Configuration
DEFAULT_STEP=5
MAX_VOLUME=100
MIN_VOLUME=0
NOTIFICATION_TIMEOUT=2000

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    local level=$1
    shift
    case $level in
        "ERROR") echo -e "${RED}[ERROR]${NC} $*" >&2 ;;
        "WARN")  echo -e "${YELLOW}[WARN]${NC} $*" >&2 ;;
        "INFO")  echo -e "${GREEN}[INFO]${NC} $*" ;;
    esac
}

# Vérifier si wpctl est disponible
check_dependencies() {
    if ! command -v wpctl &> /dev/null; then
        log "ERROR" "wpctl (WirePlumber) n'est pas installé ou accessible"
        exit 1
    fi
    
    if ! command -v bc &> /dev/null; then
        log "ERROR" "bc (calculatrice) n'est pas installé ou accessible"
        exit 1
    fi
    
    if ! command -v notify-send &> /dev/null; then
        log "WARN" "notify-send n'est pas disponible, les notifications sont désactivées"
        return 1
    fi
    return 0
}

# Obtenir le volume du périphérique de sortie
get_volume() {
    local device=${1:-"@DEFAULT_AUDIO_SINK@"}
    local volume_info
    
    volume_info=$(wpctl get-volume "$device" 2>/dev/null)
    if [ $? -ne 0 ]; then
        log "ERROR" "Impossible d'obtenir le volume pour $device"
        return 1
    fi
    
    echo "$volume_info" | awk '{print int($2*100)}'
}

# Vérifier si le périphérique est muet
is_muted() {
    local device=${1:-"@DEFAULT_AUDIO_SINK@"}
    wpctl get-volume "$device" 2>/dev/null | grep -q "MUTED"
}

# Obtenir l'icône appropriée selon le niveau de volume
get_volume_icon() {
    local volume=$1
    local is_muted=$2
    
    if [ "$is_muted" = "true" ]; then
        echo "audio-volume-muted"
    elif [ "$volume" -eq 0 ]; then
        echo "audio-volume-muted"
    elif [ "$volume" -lt 30 ]; then
        echo "audio-volume-low"
    elif [ "$volume" -lt 70 ]; then
        echo "audio-volume-medium"
    else
        echo "audio-volume-high"
    fi
}

# Obtenir l'icône pour le microphone
get_mic_icon() {
    local is_muted=$1
    
    if [ "$is_muted" = "true" ]; then
        echo "microphone-sensitivity-muted"
    else
        echo "microphone-sensitivity-high"
    fi
}

# Envoyer une notification
send_notification() {
    local device_type=${1:-"speaker"}
    local device=""
    local title=""
    local icon=""
    local volume=""
    local muted=""
    
    # Choisir le périphérique selon le type
    case $device_type in
        "speaker"|"output")
            device="@DEFAULT_AUDIO_SINK@"
            title="Volume Haut-parleurs"
            ;;
        "mic"|"microphone"|"input")
            device="@DEFAULT_AUDIO_SOURCE@"
            title="Volume Microphone"
            ;;
        *)
            log "ERROR" "Type de périphérique inconnu: $device_type"
            return 1
            ;;
    esac
    
    # Vérifier si notify-send est disponible
    if ! command -v notify-send &> /dev/null; then
        return 0
    fi
    
    volume=$(get_volume "$device")
    if [ $? -ne 0 ]; then
        log "ERROR" "Impossible d'obtenir le volume pour la notification"
        return 1
    fi
    
    if is_muted "$device"; then
        muted="true"
        if [ "$device_type" = "mic" ] || [ "$device_type" = "microphone" ] || [ "$device_type" = "input" ]; then
            icon=$(get_mic_icon "true")
            notify-send -a "volume" -u normal -i "$icon" \
                       -h string:x-canonical-private-synchronous:volume \
                       -t "$NOTIFICATION_TIMEOUT" \
                       "$title" "Mute"
        else
            icon=$(get_volume_icon "$volume" "true")
            notify-send -a "volume" -u normal -i "$icon" \
                       -h string:x-canonical-private-synchronous:volume \
                       -t "$NOTIFICATION_TIMEOUT" \
                       "$title" "Mute"
        fi
    else
        muted="false"
        if [ "$device_type" = "mic" ] || [ "$device_type" = "microphone" ] || [ "$device_type" = "input" ]; then
            icon=$(get_mic_icon "false")
        else
            icon=$(get_volume_icon "$volume" "false")
        fi
        
        notify-send -a "volume" -u normal -i "$icon" \
                   -h string:x-canonical-private-synchronous:volume \
                   -h int:value:"$volume" \
                   -t "$NOTIFICATION_TIMEOUT" \
                   "$title" "${volume}%"
    fi
}

# Ajuster le volume
adjust_volume() {
    local action=$1
    local step=${2:-$DEFAULT_STEP}
    local device="@DEFAULT_AUDIO_SINK@"
    
    # Valider le step
    if ! [[ "$step" =~ ^[0-9]+$ ]] || [ "$step" -lt 1 ] || [ "$step" -gt 50 ]; then
        log "ERROR" "Step invalide: $step (doit être entre 1 et 50)"
        return 1
    fi
    
    case $action in
        "up")
            # Convertir MAX_VOLUME en décimal pour wpctl
            local max_volume_decimal=$(echo "scale=2; $MAX_VOLUME / 100" | bc 2>/dev/null)
            wpctl set-volume "$device" "${step}%+" -l "$max_volume_decimal"
            if [ $? -eq 0 ]; then
                log "INFO" "Volume augmenté de ${step}%"
                send_notification "speaker"
            else
                log "ERROR" "Échec de l'augmentation du volume"
                return 1
            fi
            ;;
        "down")
            wpctl set-volume "$device" "${step}%-"
            if [ $? -eq 0 ]; then
                log "INFO" "Volume diminué de ${step}%"
                send_notification "speaker"
            else
                log "ERROR" "Échec de la diminution du volume"
                return 1
            fi
            ;;
        *)
            log "ERROR" "Action invalide: $action"
            return 1
            ;;
    esac
}

# Définir le volume à une valeur spécifique
set_volume() {
    local volume=$1
    local device="@DEFAULT_AUDIO_SINK@"
    
    # Valider le volume
    if ! [[ "$volume" =~ ^[0-9]+$ ]] || [ "$volume" -lt "$MIN_VOLUME" ] || [ "$volume" -gt "$MAX_VOLUME" ]; then
        log "ERROR" "Volume invalide: $volume (doit être entre $MIN_VOLUME et $MAX_VOLUME)"
        return 1
    fi
    
    # Convertir en décimal pour wpctl
    local volume_decimal=$(echo "scale=2; $volume / 100" | bc 2>/dev/null)
    if [ $? -ne 0 ]; then
        log "ERROR" "Erreur de calcul du volume"
        return 1
    fi
    
    wpctl set-volume "$device" "$volume_decimal"
    if [ $? -eq 0 ]; then
        log "INFO" "Volume défini à ${volume}%"
        send_notification "speaker"
    else
        log "ERROR" "Échec de la définition du volume"
        return 1
    fi
}

# Basculer le mute
toggle_mute() {
    local device_type=${1:-"speaker"}
    local device=""
    
    case $device_type in
        "speaker"|"output")
            device="@DEFAULT_AUDIO_SINK@"
            ;;
        "mic"|"microphone"|"input")
            device="@DEFAULT_AUDIO_SOURCE@"
            ;;
        *)
            log "ERROR" "Type de périphérique inconnu pour mute: $device_type"
            return 1
            ;;
    esac
    
    wpctl set-mute "$device" toggle
    if [ $? -eq 0 ]; then
        log "INFO" "Mute basculé pour $device_type"
        send_notification "$device_type"
    else
        log "ERROR" "Échec du basculement mute pour $device_type"
        return 1
    fi
}

# Afficher les informations actuelles
show_status() {
    echo "=== État Audio Actuel ==="
    
    local sink_volume=$(get_volume "@DEFAULT_AUDIO_SINK@")
    local source_volume=$(get_volume "@DEFAULT_AUDIO_SOURCE@")
    
    echo -n "Haut-parleurs: ${sink_volume}%"
    if is_muted "@DEFAULT_AUDIO_SINK@"; then
        echo " (MUTE)"
    else
        echo ""
    fi
    
    echo -n "Microphone: ${source_volume}%"
    if is_muted "@DEFAULT_AUDIO_SOURCE@"; then
        echo " (MUTE)"
    else
        echo ""
    fi
    
    echo "========================="
}

# Afficher l'aide
show_help() {
    cat << EOF
Script de contrôle du volume amélioré v2.0

USAGE:
    $0 [COMMANDE] [OPTIONS]

COMMANDES:
    up [step]           Augmenter le volume (défaut: ${DEFAULT_STEP}%)
    down [step]         Diminuer le volume (défaut: ${DEFAULT_STEP}%)
    mute                Basculer mute des haut-parleurs
    mic-mute            Basculer mute du microphone
    set <volume>        Définir le volume à une valeur spécifique (0-${MAX_VOLUME})
    show                Afficher l'état actuel
    help                Afficher cette aide

OPTIONS:
    step                Incrément pour up/down (1-50, défaut: ${DEFAULT_STEP})

EXEMPLES:
    $0 up               # Augmenter de ${DEFAULT_STEP}%
    $0 up 10            # Augmenter de 10%
    $0 down 3           # Diminuer de 3%
    $0 set 50           # Définir à 50%
    $0 mute             # Basculer mute haut-parleurs
    $0 mic-mute         # Basculer mute microphone
    $0 show             # Afficher l'état

DÉPENDANCES:
    - wpctl (WirePlumber)
    - notify-send (optionnel, pour les notifications)
    - bc (pour les calculs)

EOF
}

# Point d'entrée principal
main() {
    # Vérifier les dépendances
    check_dependencies
    
    # Analyser les arguments
    case ${1:-"help"} in
        "up")
            adjust_volume "up" "$2"
            ;;
        "down")
            adjust_volume "down" "$2"
            ;;
        "mute")
            toggle_mute "speaker"
            ;;
        "mic-mute")
            toggle_mute "mic"
            ;;
        "set")
            if [ -z "$2" ]; then
                log "ERROR" "Volume requis pour la commande 'set'"
                show_help
                exit 1
            fi
            set_volume "$2"
            ;;
        "show")
            show_status
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log "ERROR" "Commande inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

# Exécuter le script si appelé directement
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
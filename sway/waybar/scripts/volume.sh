#!/bin/bash

# Enhanced volume control script with Mako notifications
# Version: 2.0
# Usage: volume.sh [up|down|mute|mic-mute|show|set <value>] [step]

# Configuration
DEFAULT_STEP=5
MAX_VOLUME=100
MIN_VOLUME=0
NOTIFICATION_TIMEOUT=2000

# Colors for logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    case $level in
        "ERROR") echo -e "${RED}[ERROR]${NC} $*" >&2 ;;
        "WARN")  echo -e "${YELLOW}[WARN]${NC} $*" >&2 ;;
        "INFO")  echo -e "${GREEN}[INFO]${NC} $*" ;;
    esac
}

# Check if wpctl is available
check_dependencies() {
    if ! command -v wpctl &> /dev/null; then
        log "ERROR" "wpctl (WirePlumber) is not installed or accessible"
        exit 1
    fi
    
    if ! command -v bc &> /dev/null; then
        log "ERROR" "bc (calculator) is not installed or accessible"
        exit 1
    fi
    
    if ! command -v notify-send &> /dev/null; then
        log "WARN" "notify-send is not available, notifications are disabled"
        return 1
    fi
    return 0
}

# Get volume of output device
get_volume() {
    local device=${1:-"@DEFAULT_AUDIO_SINK@"}
    local volume_info
    
    volume_info=$(wpctl get-volume "$device" 2>/dev/null)
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to get volume for $device"
        return 1
    fi
    
    echo "$volume_info" | awk '{print int($2*100)}'
}

# Check if device is muted
is_muted() {
    local device=${1:-"@DEFAULT_AUDIO_SINK@"}
    wpctl get-volume "$device" 2>/dev/null | grep -q "MUTED"
}

# Get appropriate icon based on volume level
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

# Get icon for microphone
get_mic_icon() {
    local is_muted=$1
    
    if [ "$is_muted" = "true" ]; then
        echo "microphone-sensitivity-muted"
    else
        echo "microphone-sensitivity-high"
    fi
}

# Send a notification
send_notification() {
    local device_type=${1:-"speaker"}
    local device=""
    local title=""
    local icon=""
    local volume=""
    local muted=""
    
    # Choose device based on type
    case $device_type in
        "speaker"|"output")
            device="@DEFAULT_AUDIO_SINK@"
            title="Speaker Volume"
            ;;
        "mic"|"microphone"|"input")
            device="@DEFAULT_AUDIO_SOURCE@"
            title="Microphone Volume"
            ;;
        *)
            log "ERROR" "Unknown device type: $device_type"
            return 1
            ;;
    esac
    
    # Check if notify-send is available
    if ! command -v notify-send &> /dev/null; then
        return 0
    fi
    
    volume=$(get_volume "$device")
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to get volume for notification"
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

# Adjust volume
adjust_volume() {
    local action=$1
    local step=${2:-$DEFAULT_STEP}
    local device="@DEFAULT_AUDIO_SINK@"
    
    # Validate step
    if ! [[ "$step" =~ ^[0-9]+$ ]] || [ "$step" -lt 1 ] || [ "$step" -gt 50 ]; then
        log "ERROR" "Invalid step: $step (must be between 1 and 50)"
        return 1
    fi
    
    case $action in
        "up")
            # Convert MAX_VOLUME to decimal for wpctl
            local max_volume_decimal=$(echo "scale=2; $MAX_VOLUME / 100" | bc 2>/dev/null)
            wpctl set-volume "$device" "${step}%+" -l "$max_volume_decimal"
            if [ $? -eq 0 ]; then
                log "INFO" "Volume increased by ${step}%"
                send_notification "speaker"
            else
                log "ERROR" "Failed to increase volume"
                return 1
            fi
            ;;
        "down")
            wpctl set-volume "$device" "${step}%-"
            if [ $? -eq 0 ]; then
                log "INFO" "Volume decreased by ${step}%"
                send_notification "speaker"
            else
                log "ERROR" "Failed to decrease volume"
                return 1
            fi
            ;;
        *)
            log "ERROR" "Invalid action: $action"
            return 1
            ;;
    esac
}

# Set volume to a specific value
set_volume() {
    local volume=$1
    local device="@DEFAULT_AUDIO_SINK@"
    
    # Validate volume
    if ! [[ "$volume" =~ ^[0-9]+$ ]] || [ "$volume" -lt "$MIN_VOLUME" ] || [ "$volume" -gt "$MAX_VOLUME" ]; then
        log "ERROR" "Invalid volume: $volume (must be between $MIN_VOLUME and $MAX_VOLUME)"
        return 1
    fi
    
    # Convert to decimal for wpctl
    local volume_decimal=$(echo "scale=2; $volume / 100" | bc 2>/dev/null)
    if [ $? -ne 0 ]; then
        log "ERROR" "Volume calculation error"
        return 1
    fi
    
    wpctl set-volume "$device" "$volume_decimal"
    if [ $? -eq 0 ]; then
        log "INFO" "Volume set to ${volume}%"
        send_notification "speaker"
    else
        log "ERROR" "Failed to set volume"
        return 1
    fi
}

# Toggle mute
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
            log "ERROR" "Unknown device type for mute: $device_type"
            return 1
            ;;
    esac
    
    wpctl set-mute "$device" toggle
    if [ $? -eq 0 ]; then
        log "INFO" "Mute toggled for $device_type"
        send_notification "$device_type"
    else
        log "ERROR" "Failed to toggle mute for $device_type"
        return 1
    fi
}

# Display current information
show_status() {
    echo "=== Current Audio Status ==="
    
    local sink_volume=$(get_volume "@DEFAULT_AUDIO_SINK@")
    local source_volume=$(get_volume "@DEFAULT_AUDIO_SOURCE@")
    
    echo -n "Speakers: ${sink_volume}%"
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

# Display help
show_help() {
    cat << EOF
Enhanced volume control script v2.0

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    up [step]           Increase volume (default: ${DEFAULT_STEP}%)
    down [step]         Decrease volume (default: ${DEFAULT_STEP}%)
    mute                Toggle speaker mute
    mic-mute            Toggle microphone mute
    set <volume>        Set volume to a specific value (0-${MAX_VOLUME})
    show                Display current status
    help                Display this help

OPTIONS:
    step                Increment for up/down (1-50, default: ${DEFAULT_STEP})

EXAMPLES:
    $0 up               # Increase by ${DEFAULT_STEP}%
    $0 up 10            # Increase by 10%
    $0 down 3           # Decrease by 3%
    $0 set 50           # Set to 50%
    $0 mute             # Toggle speaker mute
    $0 mic-mute         # Toggle microphone mute
    $0 show             # Display status

DEPENDENCIES:
    - wpctl (WirePlumber)
    - notify-send (optional, for notifications)
    - bc (for calculations)

EOF
}

# Main entry point
main() {
    # Check dependencies
    check_dependencies
    
    # Parse arguments
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
                log "ERROR" "Volume required for 'set' command"
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
            log "ERROR" "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Execute the script if called directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi

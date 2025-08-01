#!/bin/bash

# ==============================================================================
# DOTFILES RESTORATION SCRIPT
# ==============================================================================
# Description: Restore saved dotfiles configurations from backups
# Author: [Alamine Dione ]
# Version: 2.0
# ==============================================================================

set -e

# ==============================================================================
# CONSTANTS AND CONFIGURATION
# ==============================================================================

# Color definitions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Directory paths
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_BASE_DIR="$HOME/.petit-rice-backups"
readonly CONFIG_DIR="$HOME/.config"

# Configuration lists (must match install.sh)
readonly -a APPS=(
    "foot" 
    "nvim" 
    "sway" 
    "swaylock" 
    "wofi" 
    "mako" 
    "fastfetch" 
    "hypr" 
    "ghostty"
    "mpd"
    "rmpc"
)

readonly -a HOME_FILES=(
    ".aliases.sh" 
    ".wallpaper" 
    ".fdignore" 
    ".tgpt_aliases.sh" 
    ".vimrc" 
    ".vim" 
    ".zshrc"
)

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# Display functions
print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ ${1}${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Interactive functions
ask_yes_no() {
    local prompt="$1"
    local response
    
    while true; do
        read -p "$(echo -e "${YELLOW}${prompt} (y/n): ${NC}")" response
        case "${response,,}" in
            y|yes) return 0 ;;
            n|no)  return 1 ;;
            *)     echo "Please answer 'y' (yes) or 'n' (no)." ;;
        esac
    done
}

# Progress indicator
show_progress() {
    local message="$1"
    echo -ne "${BLUE}⏳ ${message}...${NC}"
}

complete_progress() {
    echo -e "\r${GREEN}✅ Done!${NC}                    "
}

# ==============================================================================
# BACKUP LISTING FUNCTIONS
# ==============================================================================

get_backup_list() {
    if [[ ! -d "$BACKUP_BASE_DIR" ]]; then
        return 1
    fi
    
    find "$BACKUP_BASE_DIR" -maxdepth 1 -type d -name "backup-*" -o -name "safety-backup-*" | 
        sort -r | 
        xargs -r basename -a
}

format_backup_date() {
    local timestamp="$1"
    # Convert YYYYMMDD-HHMMSS to readable format
    local date_part="${timestamp:0:8}"
    local time_part="${timestamp:9:6}"
    
    local year="${date_part:0:4}"
    local month="${date_part:4:2}"
    local day="${date_part:6:2}"
    local hour="${time_part:0:2}"
    local minute="${time_part:2:2}"
    local second="${time_part:4:2}"
    
    echo "${day}/${month}/${year} at ${hour}:${minute}:${second}"
}

list_backups() {
    print_header "AVAILABLE BACKUPS"
    
    if [[ ! -d "$BACKUP_BASE_DIR" ]]; then
        print_error "No backup directory found: $BACKUP_BASE_DIR"
        return 1
    fi
    
    local backups=($(get_backup_list | grep "^backup-"))
    
    if [[ ${#backups[@]} -eq 0 ]]; then
        print_error "No backups found in $BACKUP_BASE_DIR"
        return 1
    fi
    
    echo -e "${CYAN}Found ${#backups[@]} backup(s):${NC}\n"
    
    for i in "${!backups[@]}"; do
        local backup="${backups[$i]}"
        local timestamp="${backup#backup-}"
        local backup_path="$BACKUP_BASE_DIR/$backup"
        
        echo -e "${BLUE}$((i+1)).${NC} ${GREEN}$(format_backup_date "$timestamp")${NC}"
        echo -e "    ${CYAN}Timestamp:${NC} $timestamp"
        
        # Display backup information if available
        if [[ -f "$backup_path/backup-info.txt" ]]; then
            echo -e "    ${CYAN}Contents:${NC}"
            grep "^  " "$backup_path/backup-info.txt" | sed 's/^/      /'
        else
            echo -e "    ${CYAN}Contents:${NC} $(ls -1 "$backup_path" | tr '\n' ', ' | sed 's/, $//')"
        fi
        
        # Show backup size
        local size=$(du -sh "$backup_path" 2>/dev/null | cut -f1)
        echo -e "    ${CYAN}Size:${NC} $size"
        echo ""
    done
    
    return 0
}

show_backup_details() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [[ ! -d "$backup_path" ]]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    print_header "BACKUP DETAILS: $(format_backup_date "$timestamp")"
    
    echo -e "${CYAN}Timestamp:${NC} $timestamp"
    echo -e "${CYAN}Path:${NC} $backup_path"
    echo -e "${CYAN}Size:${NC} $(du -sh "$backup_path" | cut -f1)"
    echo ""
    
    if [[ -f "$backup_path/backup-info.txt" ]]; then
        echo -e "${CYAN}Backup Information:${NC}"
        echo "────────────────────────────────────────"
        cat "$backup_path/backup-info.txt"
    else
        echo -e "${CYAN}Backup Contents:${NC}"
        echo "────────────────────────────────────────"
        ls -la "$backup_path"
    fi
    echo ""
}

# ==============================================================================
# SAFETY BACKUP FUNCTIONS
# ==============================================================================

create_safety_backup() {
    local safety_timestamp="$(date +%Y%m%d-%H%M%S)"
    local safety_backup_dir="$BACKUP_BASE_DIR/safety-backup-$safety_timestamp"
    local backup_created=false
    
    print_info "Creating safety backup before restoration..."
    
    mkdir -p "$safety_backup_dir"
    
    # Create backup info file
    cat > "$safety_backup_dir/backup-info.txt" << EOF
═══════════════════════════════════════════════════════════════
SAFETY BACKUP INFORMATION
═══════════════════════════════════════════════════════════════
Date: $(date)
Timestamp: $safety_timestamp
Type: Safety backup (created before restoration)
═══════════════════════════════════════════════════════════════
Saved configurations:
EOF
    
    # Backup current configurations
    for app in "${APPS[@]}"; do
        local config_path="$CONFIG_DIR/$app"
        if [[ -e "$config_path" ]]; then
            show_progress "Backing up $app"
            cp -r "$config_path" "$safety_backup_dir/$app"
            echo "  ✓ $app" >> "$safety_backup_dir/backup-info.txt"
            complete_progress
            backup_created=true
        fi
    done
    
    # Backup current home files
    if [[ "$backup_created" == true ]] || find "$HOME" -maxdepth 1 \( -name ".aliases.sh" -o -name ".wallpaper" -o -name ".fdignore" -o -name ".tgpt_aliases.sh" -o -name ".vimrc" -o -name ".vim" -o -name ".zshrc" \) -print -quit | grep -q .; then
        mkdir -p "$safety_backup_dir/home"
        for home_file in "${HOME_FILES[@]}"; do
            local home_path="$HOME/$home_file"
            if [[ -e "$home_path" ]]; then
                show_progress "Backing up $home_file"
                cp -r "$home_path" "$safety_backup_dir/home/$home_file"
                echo "  ✓ home/$home_file" >> "$safety_backup_dir/backup-info.txt"
                complete_progress
                backup_created=true
            fi
        done
    fi
    
    # Backup petit-rice scripts
    if [[ -d "$CONFIG_DIR/petit-rice-scripts" ]]; then
        show_progress "Backing up petit-rice scripts"
        cp -r "$CONFIG_DIR/petit-rice-scripts" "$safety_backup_dir/petit-rice-scripts"
        echo "  ✓ petit-rice-scripts" >> "$safety_backup_dir/backup-info.txt"
        complete_progress
        backup_created=true
    fi
    
    echo "" >> "$safety_backup_dir/backup-info.txt"
    echo "═══════════════════════════════════════════════════════════════" >> "$safety_backup_dir/backup-info.txt"
    
    if [[ "$backup_created" == true ]]; then
        print_success "Safety backup created: $safety_backup_dir"
        echo "$safety_timestamp"
    else
        rmdir "$safety_backup_dir" 2>/dev/null || true
        print_info "No current configuration to backup"
        echo ""
    fi
}

# ==============================================================================
# RESTORATION FUNCTIONS
# ==============================================================================

restore_item() {
    local source_path="$1"
    local target_path="$2"
    local item_name="$3"
    
    show_progress "Restoring $item_name"
    
    # Remove existing item
    [[ -e "$target_path" ]] && rm -rf "$target_path"
    
    # Create parent directory
    mkdir -p "$(dirname "$target_path")"
    
    # Copy from backup
    cp -r "$source_path" "$target_path"
    
    complete_progress
}

restore_home_files() {
    local home_backup_dir="$1"
    
    print_info "Restoring home files..."
    
    for home_item in "$home_backup_dir"/*; do
        if [[ -e "$home_item" ]]; then
            local item_name=$(basename "$home_item")
            restore_item "$home_item" "$HOME/$item_name" "$item_name"
        fi
    done
}

restore_backup() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [[ ! -d "$backup_path" ]]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    print_header "RESTORING BACKUP"
    
    # Display backup details
    show_backup_details "$timestamp"
    
    # Confirmation
    if ! ask_yes_no "Do you really want to restore this backup?"; then
        print_info "Restoration cancelled"
        return 0
    fi
    
    # Create safety backup
    local safety_backup_timestamp=$(create_safety_backup)
    
    echo ""
    print_info "Starting restoration process..."
    echo ""
    
    # Restore each item
    for item in "$backup_path"/*; do
        if [[ -e "$item" ]]; then
            local item_name=$(basename "$item")
            
            # Skip info file
            [[ "$item_name" == "backup-info.txt" ]] && continue
            
            # Handle home folder specially
            if [[ "$item_name" == "home" ]] && [[ -d "$item" ]]; then
                restore_home_files "$item"
                continue
            fi
            
            # Restore to config directory
            restore_item "$item" "$CONFIG_DIR/$item_name" "$item_name"
        fi
    done
    
    # Configure vim plugins
    if [[ -f "$SCRIPT_DIR/scripts/config-vim.sh" ]]; then
        echo ""
        print_info "Configuring Vim plugins..."
        bash "$SCRIPT_DIR/scripts/config-vim.sh"
    fi
    
    echo ""
    print_success "Restoration completed successfully! ✨"
    
    if [[ -n "$safety_backup_timestamp" ]]; then
        echo ""
        print_info "Safety backup available: $safety_backup_timestamp"
        echo -e "${CYAN}To undo this restoration:${NC} ./restore.sh $safety_backup_timestamp"
    fi
    
    echo "reloading config"
    bash "$SCRIPT_DIR/scripts/reload-config.sh"
    print_warning "Please restart your session to apply all changes"
}

# ==============================================================================
# BACKUP MANAGEMENT FUNCTIONS
# ==============================================================================

delete_backup() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [[ ! -d "$backup_path" ]]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    print_header "DELETE BACKUP"
    
    show_backup_details "$timestamp"
    
    if ask_yes_no "Do you really want to delete this backup? This action is irreversible."; then
        rm -rf "$backup_path"
        print_success "Backup deleted: $timestamp"
    else
        print_info "Deletion cancelled"
    fi
}

cleanup_old_backups() {
    print_header "CLEANUP OLD BACKUPS"
    
    if [[ ! -d "$BACKUP_BASE_DIR" ]]; then
        print_info "No backup directory found"
        return 0
    fi
    
    local all_backups=($(get_backup_list))
    local backup_count=${#all_backups[@]}
    
    print_info "Total backups found: $backup_count"
    
    if [[ $backup_count -le 10 ]]; then
        print_info "Less than 10 backups, no cleanup necessary"
        return 0
    fi
    
    local to_delete=(${all_backups[@]:10})
    
    echo ""
    echo -e "${YELLOW}Old backups to delete (keeping 10 most recent):${NC}"
    for backup in "${to_delete[@]}"; do
        local timestamp="${backup#*-}"
        echo "  • $(format_backup_date "$timestamp") ($backup)"
    done
    
    echo ""
    if ask_yes_no "Delete these ${#to_delete[@]} old backups?"; then
        for backup in "${to_delete[@]}"; do
            rm -rf "$BACKUP_BASE_DIR/$backup"
            print_success "✓ Deleted: $backup"
        done
        print_success "Cleanup completed!"
    else
        print_info "Cleanup cancelled"
    fi
}

# ==============================================================================
# USER INTERFACE
# ==============================================================================

interactive_menu() {
    if ! list_backups; then
        return 1
    fi
    
    local backups=($(get_backup_list | grep "^backup-"))
    
    echo -e "${YELLOW}Select a backup to restore:${NC}\n"
    
    for i in "${!backups[@]}"; do
        local timestamp="${backups[$i]#backup-}"
        echo -e "  ${GREEN}$((i+1))${NC}) $(format_backup_date "$timestamp")"
    done
    
    echo -e "  ${RED}$((${#backups[@]}+1))${NC}) Cancel operation"
    echo ""
    
    local max_choice=$((${#backups[@]}+1))
    local choice
    
    read -p "$(echo -e "${YELLOW}Your choice (1-$max_choice): ${NC}")" choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#backups[@]} ]]; then
        local selected_backup="${backups[$((choice-1))]}"
        local timestamp="${selected_backup#backup-}"
        restore_backup "$timestamp"
    elif [[ "$choice" -eq $max_choice ]]; then
        print_info "Operation cancelled"
    else
        print_error "Invalid choice"
    fi
}

show_help() {
    print_header "RESTORE SCRIPT HELP"
    
    echo -e "${CYAN}Description:${NC}"
    echo "  This script allows you to restore dotfiles configurations from backups."
    echo ""
    
    echo -e "${CYAN}Usage:${NC}"
    echo "  $0 [COMMAND] [ARGUMENTS]"
    echo ""
    
    echo -e "${CYAN}Commands:${NC}"
    echo "  ${GREEN}(no command)${NC}              Interactive menu mode"
    echo "  ${GREEN}<timestamp>${NC}               Restore a specific backup"
    echo "  ${GREEN}list${NC}                      List all available backups"
    echo "  ${GREEN}details <timestamp>${NC}       Show detailed information about a backup"
    echo "  ${GREEN}delete <timestamp>${NC}        Delete a specific backup"
    echo "  ${GREEN}cleanup${NC}                   Remove old backups (keeps 10 most recent)"
    echo "  ${GREEN}help${NC}                      Show this help message"
    echo ""
    
    echo -e "${CYAN}Examples:${NC}"
    echo "  $0                          # Start interactive mode"
    echo "  $0 20240127-143052          # Restore specific backup"
    echo "  $0 list                     # List all backups"
    echo "  $0 details 20240127-143052  # Show backup details"
    echo "  $0 delete 20240127-143052   # Delete a backup"
    echo ""
    
    echo -e "${CYAN}Backup Format:${NC}"
    echo "  Timestamps are in format: YYYYMMDD-HHMMSS"
    echo "  Example: 20240127-143052 (January 27, 2024 at 14:30:52)"
}

# ==============================================================================
# MAIN ENTRY POINT
# ==============================================================================

main() {
    # Create backup directory if it doesn't exist
    [[ ! -d "$BACKUP_BASE_DIR" ]] && mkdir -p "$BACKUP_BASE_DIR"
    
    # Process command-line arguments
    case "${1:-}" in
        "list")
            list_backups
            ;;
        "details")
            if [[ -z "$2" ]]; then
                print_error "Timestamp required for 'details' command"
                echo -e "Usage: ${YELLOW}$0 details <timestamp>${NC}"
                exit 1
            fi
            show_backup_details "$2"
            ;;
        "delete")
            if [[ -z "$2" ]]; then
                print_error "Timestamp required for 'delete' command"
                echo -e "Usage: ${YELLOW}$0 delete <timestamp>${NC}"
                exit 1
            fi
            delete_backup "$2"
            ;;
        "cleanup")
            cleanup_old_backups
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        "")
            # Interactive menu if no argument provided
            clear
            print_header "DOTFILES RESTORATION"
            interactive_menu
            ;;
        *)
            # Attempt to restore a specific backup
            if [[ "$1" =~ ^[0-9]{8}-[0-9]{6}$ ]]; then
                restore_backup "$1"
            else
                print_error "Invalid timestamp format: $1"
                print_info "Expected format: YYYYMMDD-HHMMSS (example: 20240127-143052)"
                echo ""
                show_help
                exit 1
            fi
            ;;
    esac
}

# Execute the main script
main "$@"


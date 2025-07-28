#!/bin/bash

# Dotfiles restoration script
# This script allows restoring a saved configuration at a given time

set -e

# Colors for display
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE_DIR="$HOME/.config-backups"
CONFIG_DIR="$HOME/.config"

# Function for colored output
print_header() {
    echo -e "${CYAN}=====================================
$1
=====================================${NC}"
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

# Function to ask for confirmation
ask_yes_no() {
    while true; do
        read -p "$(echo -e "${YELLOW}$1 (y/n): ${NC}")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y (yes) or n (no).";;
        esac
    done
}

# Function to list available backups
list_backups() {
    print_header "Available Backups"
    
    if [ ! -d "$BACKUP_BASE_DIR" ]; then
        print_error "No backup directory found: $BACKUP_BASE_DIR"
        return 1
    fi
    
    local backups=($(ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | sort -r))
    
    if [ ${#backups[@]} -eq 0 ]; then
        print_error "No backups found in $BACKUP_BASE_DIR"
        return 1
    fi
    
    echo "Available backups:"
    for i in "${!backups[@]}"; do
        local backup="${backups[$i]}"
        local timestamp="${backup#backup-}"
        local backup_path="$BACKUP_BASE_DIR/$backup"
        
        echo -e "${BLUE}$((i+1)). ${NC}$timestamp"
        
        # Display backup information if available
        if [ -f "$backup_path/backup-info.txt" ]; then
            echo -e "   ${CYAN}Date:${NC} $(grep "Backup created on:" "$backup_path/backup-info.txt" | cut -d: -f2-)"
            echo -e "   ${CYAN}Configurations:${NC}"
            grep "  - " "$backup_path/backup-info.txt" | sed 's/^/     /'
        else
            echo -e "   ${CYAN}Content:${NC} $(ls -1 "$backup_path" | tr '\n' ' ')"
        fi
        echo ""
    done
    
    return 0
}

# Function to show backup details
show_backup_details() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [ ! -d "$backup_path" ]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    print_header "Backup Details: $timestamp"
    
    if [ -f "$backup_path/backup-info.txt" ]; then
        cat "$backup_path/backup-info.txt"
    else
        echo "Backup content:"
        ls -la "$backup_path"
    fi
    
    echo ""
    print_info "Backup size: $(du -sh "$backup_path" | cut -f1)"
}

# Function to create a safety backup before restoration
create_safety_backup() {
    local safety_timestamp="$(date +%Y%m%d-%H%M%S)"
    local safety_backup_dir="$BACKUP_BASE_DIR/safety-backup-$safety_timestamp"
    
    print_info "Creating a safety backup before restoration..."
    
    mkdir -p "$safety_backup_dir"
    
    # Create an info file
    cat > "$safety_backup_dir/backup-info.txt" << EOF
Backup created on: $(date)
Timestamp: $safety_timestamp
Created before restoration
Saved configurations:
EOF
    
    local apps=("foot" "kitty" "nvim" "sway" "swaylock" "waybar" "wofi" "mako" "fastfetch" "hypr")
    local home_files=(".aliases.sh" ".fdignore" ".tgpt_aliases.sh" ".vimrc" ".viminfo" ".vim")
    local backup_created=false
    
    # Backup current configurations
    for app in "${apps[@]}"; do
        local config_path="$CONFIG_DIR/$app"
        if [ -d "$config_path" ] || [ -f "$config_path" ]; then
            cp -r "$config_path" "$safety_backup_dir/$app"
            echo "  - $app" >> "$safety_backup_dir/backup-info.txt"
            backup_created=true
        fi
    done
    
    # Backup current home files
    mkdir -p "$safety_backup_dir/home"
    for home_file in "${home_files[@]}"; do
        local home_path="$HOME/$home_file"
        if [ -d "$home_path" ] || [ -f "$home_path" ]; then
            cp -r "$home_path" "$safety_backup_dir/home/$home_file"
            echo "  - home/$home_file" >> "$safety_backup_dir/backup-info.txt"
            backup_created=true
        fi
    done
    
    # Backup hotfiles scripts
    if [ -d "$CONFIG_DIR/hotfiles-scripts" ]; then
        cp -r "$CONFIG_DIR/hotfiles-scripts" "$safety_backup_dir/hotfiles-scripts"
        echo "  - hotfiles-scripts" >> "$safety_backup_dir/backup-info.txt"
        backup_created=true
    fi
    
    if [ "$backup_created" = true ]; then
        print_success "Safety backup created: $safety_backup_dir"
        echo "$safety_timestamp"
    else
        rmdir "$safety_backup_dir" 2>/dev/null || true
        print_info "No current configuration to backup"
        echo ""
    fi
}

# Main restoration function
restore_backup() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [ ! -d "$backup_path" ]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    print_header "Restoring backup: $timestamp"
    
    # Display backup details
    show_backup_details "$timestamp"
    
    # Ask for confirmation
    if ! ask_yes_no "Do you really want to restore this backup?"; then
        print_info "Restoration cancelled"
        return 0
    fi
    
    # Create a safety backup
    local safety_backup_timestamp=$(create_safety_backup)
    
    print_info "Starting restoration..."
    
    # Restore each item from the backup
    for item in "$backup_path"/*; do
        if [ -d "$item" ] || [ -f "$item" ]; then
            local item_name=$(basename "$item")
            
            # Ignore the info file
            if [ "$item_name" = "backup-info.txt" ]; then
                continue
            fi
            
            # Special handling for the home folder
            if [ "$item_name" = "home" ] && [ -d "$item" ]; then
                print_info "Restoring home files..."
                
                # Restore each file/folder from home
                for home_item in "$item"/*; do
                    if [ -e "$home_item" ]; then
                        local home_item_name=$(basename "$home_item")
                        local target_path="$HOME/$home_item_name"
                        
                        print_info "Restoring $home_item_name to home..."
                        
                        # Delete the current file/folder if it exists
                        if [ -d "$target_path" ] || [ -f "$target_path" ]; then
                            rm -rf "$target_path"
                        fi
                        
                        # Copy the backed-up file/folder
                        cp -r "$home_item" "$target_path"
                        
                        print_success "✓ $home_item_name restored to home"
                    fi
                done
                continue
            fi
            
            local target_path="$CONFIG_DIR/$item_name"
            
            print_info "Restoring $item_name..."
            
            # Delete the current configuration if it exists
            if [ -d "$target_path" ] || [ -f "$target_path" ]; then
                rm -rf "$target_path"
            fi
            
            # Create parent directory if necessary
            mkdir -p "$(dirname "$target_path")"
            
            # Copy the backed-up configuration
            cp -r "$item" "$target_path"
            
            print_success "✓ $item_name restored"
        fi
    done
    
    # install the vim plugins
    print_infos "Installing vim plugins..."
    bash "$SCRIPT_DIR/scripts/config-vim.sh"
   
    print_success "Restoration completed successfully!"
    
    if [ -n "$safety_backup_timestamp" ]; then
        print_info "Safety backup available: $safety_backup_timestamp"
        print_info "To undo this restoration: ./restore.sh $safety_backup_timestamp"
    fi
    
    print_warning "Restart your session to apply all changes"
}

# Function to delete a backup
delete_backup() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [ ! -d "$backup_path" ]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    show_backup_details "$timestamp"
    
    if ask_yes_no "Do you really want to delete this backup? This action is irreversible."; then
        rm -rf "$backup_path"
        print_success "Backup $timestamp deleted"
    else
        print_info "Deletion cancelled"
    fi
}

# Function to clean up old backups
cleanup_old_backups() {
    print_header "Cleaning up old backups"
    
    if [ ! -d "$BACKUP_BASE_DIR" ]; then
        print_info "No backup directory found"
        return 0
    fi
    
    local backups=($(ls -1 "$BACKUP_BASE_DIR" | grep "^backup-\|^safety-backup-" | sort))
    local backup_count=${#backups[@]}
    
    print_info "Total number of backups: $backup_count"
    
    if [ $backup_count -le 10 ]; then
        print_info "Less than 10 backups, no cleanup necessary"
        return 0
    fi
    
    print_info "Old backups (more than 10):"
    local to_delete=(${backups[@]:0:$((backup_count-10))})
    
    for backup in "${to_delete[@]}"; do
        echo "  - $backup"
    done
    
    if ask_yes_no "Do you want to delete these old backups?"; then
        for backup in "${to_delete[@]}"; do
            rm -rf "$BACKUP_BASE_DIR/$backup"
            print_success "✓ $backup deleted"
        done
        print_success "Cleanup complete"
    else
        print_info "Cleanup cancelled"
    fi
}

# Interactive selection menu
interactive_menu() {
    if ! list_backups; then
        return 1
    fi
    
    local backups=($(ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | sort -r))
    
    echo -e "${YELLOW}Choose a backup to restore:${NC}"
    for i in "${!backups[@]}"; do
        local timestamp="${backups[$i]#backup-}"
        echo "$((i+1)). $timestamp"
    done
    echo "$((${#backups[@]}+1)). Cancel"
    echo ""
    
    read -p "$(echo -e "${YELLOW}Your choice (1-$((${#backups[@]}+1))): ${NC}")" choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#backups[@]} ]; then
        local selected_backup="${backups[$((choice-1))]}"
        local timestamp="${selected_backup#backup-}"
        restore_backup "$timestamp"
    elif [ "$choice" -eq $((${#backups[@]}+1)) ]; then
        print_info "Operation cancelled"
    else
        print_error "Invalid choice"
    fi
}

# Help function
show_help() {
    echo "Dotfiles restoration script"
    echo ""
    echo "Usage:"
    echo "  $0                          - Interactive menu"
    echo "  $0 <timestamp>              - Restore a specific backup"
    echo "  $0 list                     - List available backups"
    echo "  $0 details <timestamp>      - Show details of a backup"
    echo "  $0 delete <timestamp>       - Delete a backup"
    echo "  $0 cleanup                  - Clean up old backups"
    echo "  $0 help                     - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 20240127-143052          - Restore backup from 27/01/2024 at 14:30:52"
    echo "  $0 list                     - See all backups"
    echo "  $0 details 20240127-143052  - See details of a backup"
}

# Main entry point
main() {
    case "${1:-}" in
        "list")
            list_backups
            ;;
        "details")
            if [ -z "$2" ]; then
                print_error "Timestamp required for 'details'"
                echo "Usage: $0 details <timestamp>"
                exit 1
            fi
            show_backup_details "$2"
            ;;
        "delete")
            if [ -z "$2" ]; then
                print_error "Timestamp required for 'delete'"
                echo "Usage: $0 delete <timestamp>"
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
            # Interactive menu if no argument
            print_header "Dotfiles Restoration Script"
            interactive_menu
            ;;
        *)
            # Restore a specific backup
            if [[ "$1" =~ ^[0-9]{8}-[0-9]{6}$ ]]; then
                restore_backup "$1"
            else
                print_error "Invalid timestamp format: $1"
                print_info "Expected format: YYYYMMDD-HHMMSS (ex: 20240127-143052)"
                show_help
                exit 1
            fi
            ;;
    esac
}

# Execute the main script
main "$@"

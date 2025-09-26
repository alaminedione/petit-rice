#!/bin/bash

# ==============================================================================
# DOTFILES INSTALLATION SCRIPT
# ==============================================================================
# Description: Automatic dotfiles installation with backup and theme management
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
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
readonly BACKUP_BASE_DIR="$HOME/.petit-rice-backups"
readonly BACKUP_DIR="$BACKUP_BASE_DIR/backup-$TIMESTAMP"
readonly CONFIG_DIR="$HOME/.config"

# Configuration lists
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
    ".fdignore" 
    ".tgpt_aliases.sh" 
    ".vimrc" 
    ".vim" 
    ".zshrc" 
    ".wallpaper"
)

readonly -a OPTIONAL_SCRIPTS=(
    "scripts/fix_fonts.sh:Font correction"
    "scripts/set-swapinness.sh:Swapiness configuration"
    "scripts/create_macspoof_service.sh:Creating macspoof service"
    "scripts/setup-bluetooth.sh:Setup bluetooth"
    "scripts/config-npm.sh:Configuring npm to use a user-specific directory for global packages and updating the .zshrc file to add the new directory to the system's PATH"
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
    local message="$1"
    echo -e "\r${GREEN}✅ ${message} - Completed${NC}"
}
# ==============================================================================
# BACKUP FUNCTIONS
# ==============================================================================

check_backup_needed() {
    # Check applications
    for app in "${APPS[@]}"; do
        [[ -e "$CONFIG_DIR/$app" ]] && return 0
    done
    
    # Check petit-rice scripts
    [[ -d "$CONFIG_DIR/petit-rice-scripts" ]] && return 0
    
    # Check home files
    for file in "${HOME_FILES[@]}"; do
        [[ -e "$HOME/$file" ]] && return 0
    done
    
    return 1
}

create_backup_info() {
    cat > "$BACKUP_DIR/backup-info.txt" << EOF
═══════════════════════════════════════════════════════════════
BACKUP INFORMATION
═══════════════════════════════════════════════════════════════
Date: $(date)
Timestamp: $TIMESTAMP
Script: $0
Source: $SCRIPT_DIR
═══════════════════════════════════════════════════════════════
Backed up configurations:
EOF
}

backup_item() {
    local item_path="$1"
    local backup_path="$2"
    local item_name="$3"
    
    if [[ -e "$item_path" ]]; then
        print_info "Backing up $item_name..."
        cp -r "$item_path" "$backup_path"
        echo "  ✓ $item_name" >> "$BACKUP_DIR/backup-info.txt"
        print_success "Backed up: $item_name"
        return 0
    fi
    return 1
}


create_global_backup() {
    print_info "Checking for existing configurations..."
    
    if ! check_backup_needed; then
        print_info "No existing configurations found, skipping backup"
        return 0
    fi
    
    print_info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    create_backup_info
    
    # Backup applications
    echo -e "\n${CYAN}Backing up application configurations:${NC}"
    for app in "${APPS[@]}"; do
        backup_item "$CONFIG_DIR/$app" "$BACKUP_DIR/$app" "$app"
    done

    sleep 2
    
    # Backup home files
    echo -e "\n${CYAN}Backing up home files:${NC}"
    mkdir -p "$BACKUP_DIR/home"
    for file in "${HOME_FILES[@]}"; do
        backup_item "$HOME/$file" "$BACKUP_DIR/home/$file" "$file"
    done

    sleep 2
    
    # Backup petit-rice scripts
    echo -e "\n${CYAN}Backing up scripts:${NC}"
    backup_item "$CONFIG_DIR/petit-rice-scripts" "$BACKUP_DIR/petit-rice-scripts" "petit-rice scripts"

    sleep 2
    
    echo "" >> "$BACKUP_DIR/backup-info.txt"
    echo "═══════════════════════════════════════════════════════════════" >> "$BACKUP_DIR/backup-info.txt"

    
    echo ""
    print_success "Backup completed: $BACKUP_DIR"
    echo -e "${GREEN}📁 Restore with: ./restore.sh $TIMESTAMP${NC}\n"

    sleep 2
}

# ==============================================================================
# INSTALLATION FUNCTIONS
# ==============================================================================

validate_source_directory() {
    if [[ ! -d "$SCRIPT_DIR" ]]; then
        print_error "Source directory not found: $SCRIPT_DIR"
        exit 1
    fi
}

install_config() {
    local app_name="$1"
    local source_dir="$SCRIPT_DIR/$app_name"
    local target_dir="$CONFIG_DIR/$app_name"
    
    if [[ ! -d "$source_dir" ]]; then
        print_warning "$app_name configuration not found in $source_dir"
        return 1
    fi
    
    print_info "Installing $app_name configuration..."
    
    # Create parent directory
    mkdir -p "$(dirname "$target_dir")"
    
    # Remove existing configuration
    [[ -e "$target_dir" ]] && rm -rf "$target_dir"
    
    # Copy configuration
    cp -r "$source_dir" "$target_dir"
    
    print_success "Installed: $app_name configuration"
    return 0
}


install_home_files() {
    local source_dir="$SCRIPT_DIR/home"
    
    if [[ ! -d "$source_dir" ]]; then
        print_warning "Home directory not found in $source_dir"
        return 1
    fi
    
    print_info "Installing home files..."
    
    # Process files
    while IFS= read -r -d '' file; do
        local relative_path="${file#$source_dir/}"
        local target_path="$HOME/$relative_path"
        
        mkdir -p "$(dirname "$target_path")"
        cp "$file" "$target_path"
        print_success "✓ $relative_path"
    done < <(find "$source_dir" -type f -print0)
    
    print_success "Home files installation completed"
}

install_utility_scripts() {
    if [[ ! -d "$SCRIPT_DIR/scripts" ]]; then
        print_warning "Scripts directory not found"
        return 1
    fi
    
    print_info "Installing utility scripts..."
    
    # Make scripts executable
    find "$SCRIPT_DIR/scripts" -name "*.sh" -type f -exec chmod +x {} \;
    
    # Copy to config directory
    [[ -d "$CONFIG_DIR/petit-rice-scripts" ]] && rm -rf "$CONFIG_DIR/petit-rice-scripts"
    mkdir -p "$CONFIG_DIR/petit-rice-scripts"
    cp -r "$SCRIPT_DIR/scripts"/* "$CONFIG_DIR/petit-rice-scripts/"
    
    print_success "Utility scripts installed in $CONFIG_DIR/petit-rice-scripts/"
    sleep 2
}

create_gtk_directories() {
    mkdir -p "$HOME/.config/gtk-3.0"
    mkdir -p "$HOME/.config/gtk-4.0"
    print_success "GTK directories created"
}

# ==============================================================================
# MAIN INSTALLATION WORKFLOWS
# ==============================================================================

main_install() {
    print_header "INSTALLING DOTFILES"
    
    validate_source_directory
    
    # Create backup
    echo -e "${CYAN}═══ BACKUP PHASE ═══${NC}"
    sleep 1
    mkdir -p "$BACKUP_BASE_DIR"
    create_global_backup
    
    # Install configurations
    echo -e "\n${CYAN}═══ INSTALLATION PHASE ═══${NC}"
    echo -e "${CYAN}Installing application configurations:${NC}"
    for app in "${APPS[@]}"; do
        install_config "$app"
    done

    sleep 2
    
    # Install home files
    echo ""
    install_home_files

    sleep 2
    
    # Install vim plugins
    if [[ -f "$SCRIPT_DIR/scripts/config-vim.sh" ]]; then
        echo ""
        print_info "Configuring Vim..."
        bash "$SCRIPT_DIR/scripts/config-vim.sh"
    fi
    
    # Create GTK directories
    echo ""
    create_gtk_directories
    
    # Install utility scripts
    echo ""
    install_utility_scripts
}

install_dependencies() {
    print_header "INSTALLING DEPENDENCIES"
    
    local install_script="$SCRIPT_DIR/scripts/install-apps.sh"
    
    if [[ ! -f "$install_script" ]]; then
        print_warning "Application installation script not found"
        return 1
    fi
    
    if ask_yes_no "Install necessary applications?"; then
        print_info "Launching application installation..."
        bash "$install_script"
    fi
}

apply_default_theme() {
    print_header "APPLYING DEFAULT THEME"
    
    local theme_script="$SCRIPT_DIR/scripts/change-theme/set-default.sh"
    
    if [[ ! -f "$theme_script" ]]; then
        print_warning "Default theme script not found"
        return 1
    fi
    
    if ask_yes_no "Apply Catppuccin Macchiato theme? (recommended)"; then
        print_info "Applying theme..."
        bash "$theme_script"
        print_success "Theme applied successfully"
    fi
}

run_additional_scripts() {
    print_header "ADDITIONAL CONFIGURATION"
    
    # Run mandatory scripts
    local -a mandatory_scripts=(
        "scripts/config-vim.sh"
        "scripts/config-zsh.sh"
        "scripts/get-layan-cursors.sh"
        "scripts/get-gruvbox-gtk.sh"
        "scripts/get-luv-icons.sh"
        "scripts/get-vimix-icons.sh"
        "scripts/get-nord-gtk-theme.sh"
    )
    
    for script in "${mandatory_scripts[@]}"; do
        if [[ -f "$SCRIPT_DIR/$script" ]]; then
            print_info "Running $(basename "$script")..."
            bash "$SCRIPT_DIR/$script"
        fi
    done
    
    # Run optional scripts
    for script_info in "${OPTIONAL_SCRIPTS[@]}"; do
        IFS=':' read -r script_path script_desc <<< "$script_info"
        local full_path="$SCRIPT_DIR/$script_path"
        
        if [[ -f "$full_path" ]] && ask_yes_no "Execute: $script_desc?"; then
            print_info "Running $script_desc..."
            bash "$full_path"
            print_success "$script_desc completed"
        fi
    done
}

# ==============================================================================
# USER INTERFACE
# ==============================================================================

show_summary() {
    print_header "INSTALLATION SUMMARY"
    
    echo -e "${GREEN}✨ Installation completed successfully! ✨${NC}\n"
    
    echo -e "${CYAN}📍 Locations:${NC}"
    echo "   • Configurations: $CONFIG_DIR"
    [[ -d "$BACKUP_DIR" ]] && echo "   • Backup: $BACKUP_DIR"
    echo "   • Scripts: $CONFIG_DIR/petit-rice-scripts"
    
    echo -e "\n${YELLOW}📋 Recommended actions:${NC}"
    echo "   • Restart your session to apply all changes"
    echo "   • Verify configurations in your applications"
    echo "   • Check installed files in your home directory"
    
    if [[ -d "$SCRIPT_DIR/scripts/change-theme" ]]; then
        echo -e "\n${PURPLE}🎨 Available themes:${NC}"
        find "$SCRIPT_DIR/scripts/change-theme" -name "*.sh" -exec basename {} \; | 
            sed 's/^/   • /' | sed 's/.sh$//'
    fi
    
    if [[ -d "$BACKUP_BASE_DIR" ]]; then
        echo -e "\n${BLUE}💾 Available backups:${NC}"
        ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | 
            sed 's/^backup-/   • /' | 
            head -5
    fi
    
    echo -e "\n${GREEN}🎉 Enjoy your new setup! 🎉${NC}\n"
}

show_menu() {
    clear
    print_header "DOTFILES INSTALLATION MENU"
    
    echo "This script will configure your dotfiles with automatic backup."
    echo ""
    echo "Select an option:"
    echo ""
    echo -e "  ${GREEN}1)${NC} Complete installation (recommended)"
    echo -e "  ${BLUE}2)${NC} Install configurations only"
    echo -e "  ${BLUE}3)${NC} Install dependencies only"
    echo -e "  ${PURPLE}4)${NC} Apply default theme only"
    echo -e "  ${RED}5)${NC} Exit"
    echo ""
    
    read -p "$(echo -e "${YELLOW}Your choice (1-5): ${NC}")" choice
    
    case "$choice" in
        1)
            main_install
            install_dependencies
            run_additional_scripts
            apply_default_theme
            show_summary
            ;;
        2)
            main_install
            apply_default_theme
            show_summary
            ;;
        3)
            install_dependencies
            ;;
        4)
            apply_default_theme
            ;;
        5)
            print_info "Installation cancelled"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            sleep 2
            show_menu
            ;;
    esac
}

# ==============================================================================
# MAIN ENTRY POINT
# ==============================================================================

main() {
    # Verify script is run from correct directory
    if [[ ! -f "$SCRIPT_DIR/install.sh" ]]; then
        print_error "Please run this script from the dotfiles directory"
        exit 1
    fi
    
    show_menu
}

# Execute main function
main "$@"

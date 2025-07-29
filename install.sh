#!/bin/bash

# Automatic dotfiles installation script
# This script automatically configures themes and settings

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
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_BASE_DIR="$HOME/.config-backups"
BACKUP_DIR="$BACKUP_BASE_DIR/backup-$TIMESTAMP"
CONFIG_DIR="$HOME/.config"

# Colored display function
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

# Global backup function
create_global_backup() {
    local apps=("foot" "kitty" "nvim" "sway" "swaylock"  "wofi" "mako" "fastfetch" "hypr" "ghostty")
    local home_files=(".aliases.sh" ".fdignore" ".tgpt_aliases.sh" ".vimrc" ".viminfo" ".vim" ".zshrc")
    local backup_needed=false
    
    print_info "Checking for existing configurations..."
    
    # Check if there are configurations to backup
    for app in "${apps[@]}"; do
        local config_path="$CONFIG_DIR/$app"
        if [ -d "$config_path" ] || [ -f "$config_path" ]; then
            backup_needed=true
            break
        fi
    done
    
    # Check for existing hotfiles scripts
    if [ -d "$CONFIG_DIR/hotfiles-scripts" ]; then
        backup_needed=true
    fi
    
    # Check for existing home files
    for home_file in "${home_files[@]}"; do
        local home_path="$HOME/$home_file"
        if [ -d "$home_path" ] || [ -f "$home_path" ]; then
            backup_needed=true
            break
        fi
    done
    
    if [ "$backup_needed" = true ]; then
        print_info "Creating global backup folder: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        
        # Create a backup information file
        cat > "$BACKUP_DIR/backup-info.txt" << EOF
Backup created on: $(date)
Timestamp: $TIMESTAMP
Script used: $0
Source directory: $SCRIPT_DIR
Backed up configurations:
EOF
        
        # Backup each existing configuration
        for app in "${apps[@]}"; do
            local config_path="$CONFIG_DIR/$app"
            if [ -d "$config_path" ] || [ -f "$config_path" ]; then
                print_info "Backing up $app..."
                cp -r "$config_path" "$BACKUP_DIR/$app"
                echo "  - $app" >> "$BACKUP_DIR/backup-info.txt"
                print_success "✓ $app backed up"
            fi
        done
        
        # Backup existing home files
        mkdir -p "$BACKUP_DIR/home"
        for home_file in "${home_files[@]}"; do
            local home_path="$HOME/$home_file"
            if [ -d "$home_path" ] || [ -f "$home_path" ]; then
                print_info "Backing up $home_file..."
                cp -r "$home_path" "$BACKUP_DIR/home/$home_file"
                echo "  - home/$home_file" >> "$BACKUP_DIR/backup-info.txt"
                print_success "✓ $home_file backed up"
            fi
        done
        
        # Backup hotfiles scripts if they exist
        if [ -d "$CONFIG_DIR/hotfiles-scripts" ]; then
            print_info "Backing up hotfiles scripts..."
            cp -r "$CONFIG_DIR/hotfiles-scripts" "$BACKUP_DIR/hotfiles-scripts"
            echo "  - hotfiles-scripts" >> "$BACKUP_DIR/backup-info.txt"
            print_success "✓ Hotfiles scripts backed up"
        fi
        
        print_success "Global backup created: $BACKUP_DIR"
        echo -e "${GREEN}📁 Backup available for restoration with: ./restore.sh $TIMESTAMP${NC}"
    else
        print_info "No existing configurations found, no backup needed"
    fi
}

# Configuration installation function
install_config() {
    local app_name="$1"
    local source_dir="$SCRIPT_DIR/$app_name"
    local target_dir="$CONFIG_DIR/$app_name"
    
    if [ -d "$source_dir" ]; then
        print_info "Installing $app_name configuration..."
        
        # Create target directory
        mkdir -p "$(dirname "$target_dir")"
        
        # Remove old configuration if it exists
        if [ -d "$target_dir" ] || [ -f "$target_dir" ]; then
            rm -rf "$target_dir"
        fi
        
        # Copy files
        cp -r "$source_dir" "$target_dir"
        print_success "$app_name configuration installed"
    else
        print_warning "$app_name configuration not found in $source_dir"
    fi
}
# Home files installation function
install_home_files() {
    local source_dir="$SCRIPT_DIR/home"
    
    if [ -d "$source_dir" ]; then
        print_info "Installing home files..."
        
        # Iterate over all files in the home directory
        find "$source_dir" -type f | while read -r file; do
            # Get the relative path to the source directory
            local relative_path="${file#$source_dir/}"
            local target_path="$HOME/$relative_path"
            
            # Create parent directory if necessary
            mkdir -p "$(dirname "$target_path")"
            
            # Copy the file
            cp "$file" "$target_path"
            print_success "✓ $relative_path installed in home"
        done
        
        # Iterate over all directories in the home directory
        find "$source_dir" -type d -not -path "$source_dir" | while read -r dir; do
            # Get the relative path to the source directory
            local relative_path="${dir#$source_dir/}"
            local target_path="$HOME/$relative_path"
            
            # Create the directory
            mkdir -p "$target_path"
            print_success "✓ Directory $relative_path created in home"
        done
        
        print_success "Home files installed"
    else
        print_warning "Home directory not found in $source_dir"
    fi
}

# Function to make scripts executable
make_scripts_executable() {
    print_info "Making scripts executable..."
    find "$SCRIPT_DIR/scripts" -name "*.sh" -type f -exec chmod +x {} \;
    print_success "Scripts made executable"
}

# Main installation function
main_install() {
    print_header "Installing dotfiles"
    
    # Prerequisite check
    if [ ! -d "$SCRIPT_DIR" ]; then
        print_error "Source directory not found: $SCRIPT_DIR"
        exit 1
    fi
    
    # backup the current Dotfiles
    print_info "Backing up current Dotfiles to $BACKUP_BASE_DIR ..."
    sleep 2

    # Create base backup directory
    print_info "Creating backup directory: $BACKUP_BASE_DIR"
    mkdir -p "$BACKUP_BASE_DIR"
    sleep 1
    
    # Create global backup BEFORE installation
    print_info "Creating global backup BEFORE installation..."
    sleep 2
    create_global_backup
    sleep 2
    
    print_info "Installing dotfiles..."
    sleep 2
    # List of applications to configure
    local apps=("foot" "kitty" "nvim" "sway" "hypr" "swaylock" "wofi" "mako" "fastfetch" "ghostty")
    
    # Install configurations
    for app in "${apps[@]}"; do
        install_config "$app"
    done
    
    # Install home files
    install_home_files

    # install the vim plugins
    print_info "Installing vim plugins..."
    sleep 2
    bash "$SCRIPT_DIR/scripts/config-vim.sh"

    #create gtk-3.0 and gtk-4.0 folders
    mkdir -p ~/.config/gtk-3.0/
    mkdir -p ~/.config/gtk-4.0/


    
    # Make scripts executable
    make_scripts_executable
    
    # Copy scripts to an accessible directory
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        print_info "Installing utility scripts..."
        mkdir -p "$CONFIG_DIR/hotfiles-scripts"
        cp -r "$SCRIPT_DIR/scripts"/* "$CONFIG_DIR/hotfiles-scripts/"
        print_success "Utility scripts installed in $CONFIG_DIR/hotfiles-scripts/"
    fi
}

# Dependency installation function
install_dependencies() {
    print_header "Installing dependencies"
    
    if [ -f "$SCRIPT_DIR/scripts/install-apps.sh" ]; then
        if ask_yes_no "Do you want to install the necessary applications?"; then
            print_info "Launching application installation script..."
            bash "$SCRIPT_DIR/scripts/install-apps.sh"
        fi
    else
        print_warning "Application installation script not found"
    fi
}

# Default theme application function
apply_default_theme() {
    print_header "Applying default theme"
    
    if [ -f "$SCRIPT_DIR/scripts/change-theme/set-mocha.sh" ]; then
        if ask_yes_no "Do you want to apply the Catppuccin Mocha theme (default theme)?"; then
            print_info "Applying Catppuccin Mocha theme..."
            bash "$SCRIPT_DIR/scripts/change-theme/set-mocha.sh"
            print_success "Catppuccin Mocha theme applied"
        fi
    else
        print_warning "Default theme script not found"
    fi
}

# Function to run additional configuration scripts
run_additional_scripts() {
    print_header "Additional configuration scripts"
    
    # Optional scripts
    local optional_scripts=(
        "scripts/fix_fonts.sh:Font correction"
        "scripts/gsettings.sh:gtk settings configuration"
        "scripts/get-layan-cursors.sh:Layan cursors installation"
        "scripts/config-zsh.sh:Zsh configuration"
        "scripts/config-vim.sh:Vim configuration"
        "scripts/set-swapinness.sh:Swapiness configuration"
        "scripts/create_macspoof_service.sh:Creating macspoof service for MAC address spoofing"
    )
    
    for script_info in "${optional_scripts[@]}"; do
        IFS=':' read -ra SCRIPT_PARTS <<< "$script_info"
        local script_path="$SCRIPT_DIR/${SCRIPT_PARTS[0]}"
        local script_desc="${SCRIPT_PARTS[1]}"
        
        if [ -f "$script_path" ]; then
            if ask_yes_no "Execute: $script_desc ?"; then
                print_info "Executing $script_desc..."
                bash "$script_path"
                print_success "$script_desc completed"
            fi
        fi
    done
}

# Summary display function
show_summary() {
    print_header "Installation Summary"
    
    echo -e "${GREEN}✅ Installation completed successfully!${NC}"
    echo ""
    print_info "Configurations installed in: $CONFIG_DIR"
    if [ -d "$BACKUP_DIR" ]; then
        print_info "Backup created in: $BACKUP_DIR"
        print_info "To restore this backup: ./restore.sh $TIMESTAMP"
    fi
    print_info "Utility scripts in: $CONFIG_DIR/hotfiles-scripts"
    echo ""
    print_warning "Recommended actions:"
    echo "   - Restart your session to apply all changes"
    echo "   - Check configurations in your applications"
    echo "   - Check installed files in your home directory"
    echo "   - Use theme change scripts if necessary"
    echo ""
    print_info "Available theme scripts:"
    if [ -d "$SCRIPT_DIR/scripts/change-theme" ]; then
        find "$SCRIPT_DIR/scripts/change-theme" -name "*.sh" -exec basename {} \; | sed 's/^/   - /'
    fi
    echo ""
    print_info "Available backups:"
    if [ -d "$BACKUP_BASE_DIR" ]; then
        ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | sed 's/^backup-/   - /' | sed 's/$/ (use: .\/restore.sh <timestamp>)/'
    fi
    # afficher un messa de felicitation
    echo -e "${GREEN}✅ Installation completed successfully!${NC}"
}

# Main menu
show_menu() {
    print_header "Dotfiles Installation Script"
    echo "This script will automatically configure your dotfiles."
    echo ""
    echo "Available options:"
    echo "1. Complete installation (recommended)"
    echo "2. Install configurations only"
    echo "3. Install dependencies only"
    echo "4. Apply default theme only"
    echo "5. Exit"
    echo ""
    
    read -p "$(echo -e "${YELLOW}Choose an option (1-5): ${NC}")" choice
    
    case $choice in
        1)
            main_install
            install_dependencies
            apply_default_theme
            run_additional_scripts
            show_summary
            ;;
        2)
            main_install
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
            show_menu
            ;;
    esac
}

# Main entry point
main() {
    #TODO: Check that the script is executed from the correct directory
    
    # Display the menu
    show_menu
}

# Execute the main script
main "$@"

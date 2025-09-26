#!/bin/bash

# Interactive application installation script for Arch Linux Rice
# for Sway/Hyprland dotfiles configuration

set -e

# Colors for display
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Colored display functions
print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗"
    echo -e "║ $(printf "%-58s" "$1") ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝${NC}"
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

print_logo() {
    echo -e "${PURPLE}"
    echo "    ██████╗ ███████╗████████╗██╗████████╗   ██████╗ ██╗ ██████╗███████╗"
    echo "    ██╔══██╗██╔════╝╚══██╔══╝██║╚══██╔══╝   ██╔══██╗██║██╔════╝██╔════╝"
    echo "    ██████╔╝█████╗     ██║   ██║   ██║      ██████╔╝██║██║     █████╗  "
    echo "    ██╔═══╝ ██╔══╝     ██║   ██║   ██║      ██╔══██╗██║██║     ██╔══╝  "
    echo "    ██║     ███████╗   ██║   ██║   ██║      ██║  ██║██║╚██████╗███████╗"
    echo "    ╚═╝     ╚══════╝   ╚═╝   ╚═╝   ╚═╝      ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝"
    echo -e "${NC}"
    echo -e "${CYAN}    Sway/Hyprland Rice Installation Script${NC}"
    echo ""
}

# Function to ask for confirmation
ask_yes_no() {
    while true; do
        read -p "$(echo -e "${YELLOW}$1 (y/n): ${NC}")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer with y (yes) or n (no).";;
        esac
    done
}

# Check if user is developer
check_developer_profile() {
    echo ""
    print_info "Profile Detection"
    echo "This will help customize the installation for your needs."
    
    if ask_yes_no "Are you a developer/programmer?"; then
        IS_DEVELOPER=true
        print_success "Developer profile detected - dev tools will be included"
    else
        IS_DEVELOPER=false
        print_info "Focusing on essential packages"
    fi
    echo ""
}

# Installation function 
install_packages() {
    local category="$1"
    local description="$2"
    shift 2
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        print_warning "No packages to install for $category"
        return
    fi
    
    print_header "Installing: $description"
    echo -e "${BLUE}Packages:${NC} ${packages[*]}"
    echo ""
    
    if ask_yes_no "Install $description?"; then
        echo "📦 Installing packages..."
        
        # Progress indicator
        local total=${#packages[@]}
        local current=0
        local failed_packages=()
        
        for package in "${packages[@]}"; do
            current=$((current + 1))
            echo -e "${BLUE}[$current/$total]${NC} Installing $package..."
            
            # Try installation without suppressing stderr for better debugging
            if ! yay -S --needed --noconfirm "$package"; then
                print_error "Initial installation of $package failed."
                local retry_attempt=1
                local max_retries=10
                local install_success=false
                
                while [ $retry_attempt -le $max_retries ]; do
                    if ask_yes_no "Do you want to try reinstalling $package? (Attempt $retry_attempt/$max_retries)"; then
                        echo -e "${BLUE}[$current/$total]${NC} Retrying installation of $package... (Attempt $retry_attempt)"
                        if yay -S --needed --noconfirm "$package"; then
                            print_success "$package reinstalled successfully."
                            install_success=true
                            break
                        else
                            print_warning "Attempt $retry_attempt to install $package failed."
                            retry_attempt=$((retry_attempt + 1))
                        fi
                    else
                        print_info "Skipping $package as requested, continuing..."
                        break
                    fi
                done
                
                if [ "$install_success" = false ]; then
                    failed_packages+=("$package")
                    print_error "Failed to install $package after all attempts, continuing..."
                fi
            fi
        done
        
        # Summary
        if [ ${#failed_packages[@]} -eq 0 ]; then
            print_success "$description installed successfully"
        else
            print_warning "$description partially installed. Failed packages: ${failed_packages[*]}"
        fi
    else
        print_info "$description skipped"
    fi
    echo ""
}

# Prerequisites check
check_prerequisites() {
    print_header "Prerequisites Check"
    
    # Check yay
    if ! command -v yay &> /dev/null; then
        print_error "yay (AUR helper) is not installed"
        if ask_yes_no "Install yay now?"; then
            print_info "Installing yay..."
            sudo pacman -S --needed base-devel git
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay
            makepkg -si --noconfirm
            cd -
            rm -rf /tmp/yay
            print_success "yay installed successfully"
        else
            print_error "yay is required for this installation"
            exit 1
        fi
    else
        print_success "yay is available"
    fi
    
    # Check internet connection
    if ! ping -c 1 archlinux.org &> /dev/null; then
        print_error "No internet connection detected"
        exit 1
    fi
    print_success "Internet connection verified"
    
    # System update
    if ask_yes_no "Update system before installation? (recommended)"; then
        print_info "Updating system..."
        yay -Syu --noconfirm
        print_success "System updated"
    fi
    echo ""
}

# Package definitions optimized for rice
declare -A PACKAGES

# Essential packages for rice functionality
PACKAGES["essential"]="debugedit sway swaybg swaylock-effects swayidle hyprland hyprpaper hyprlock hypridle hyprsunset waybar wofi mako fastfetch foot ghostty neovim git curl vim rsync bc libnotify brightnessctl playerctl htop bat fd eza tree yazi zoxide galculator clipman tgpt yt-dlp slurp grim wl-clipboard adapta-gtk-theme orchis-theme kvantum lxappearance ttf-jetbrains-mono-nerd ttf-fira-code adobe-source-code-pro-fonts wireplumber pavucontrol tumbler  ffmpegthumbnailer  gtk-engine-murrine wlsunset thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman gvfs  gvfs-mtp android-udev  thunar-archive-plugin file-roller mpd rmpc mpv ripgrep trash-cli iwgtk"

# Developer essentials (if developer profile)
PACKAGES["dev"]="github-cli  nodejs pnpm npm python python-pip cargo rust go onefetch cloc typescript lazygit sccache ccache uv ts-node lazydocker-bin croc php composer hyperfine yq"


# Personal and extra packages are now installed via install_personal_apps.sh

# Installation profiles
install_minimum() {
    print_header "MINIMUM DEPENDENCIES INSTALLATION"
    print_info "Installing essential packages for rice functionality"
    
    # Always install essential packages
    IFS=' ' read -ra packages <<< "${PACKAGES[essential]}"
    install_packages "essential" "Essential Rice Packages" "${packages[@]}"
    
    # Add developer tools if developer profile
    if [ "$IS_DEVELOPER" = true ]; then
        IFS=' ' read -ra dev_packages <<< "${PACKAGES[dev]}"
        install_packages "dev" "Essential Developer Tools" "${dev_packages[@]}"
    fi
}



# Post-installation configuration
post_installation() {
    print_header "Installation Summary"
    echo -e "🎉 Essential packages installed successfully! \n"
    
    print_info "To install personal and extra applications, you can now run:"
    echo -e "${YELLOW}./scripts/install_personal_apps.sh${NC}"
    echo ""
}

# Main script execution
main() {
    clear
    print_logo
    
    print_info "Welcome to the Arch Linux Rice Installation Script"
    print_info "This script will install essential packages for Sway/Hyprland rice"
    echo ""
    
    check_prerequisites
    check_developer_profile
    
    # Handle potential conflict between swaylock and swaylock-effects
    if [[ " ${PACKAGES[essential]} " =~ " swaylock-effects " ]] && pacman -Q swaylock &> /dev/null; then
        if ask_yes_no "Conflict detected: 'swaylock' is installed, but these dotfiles use 'swaylock-effects'. Replace 'swaylock' with 'swaylock-effects'?"; then
            print_info "Removing 'swaylock' to avoid installation conflicts..."
            sudo pacman -R --noconfirm swaylock
            print_success "'swaylock' removed."
        else
            print_warning "Skipping installation of 'swaylock-effects' to keep 'swaylock'."
            PACKAGES["essential"]="${PACKAGES[essential]//swaylock-effects/}"
        fi
    fi
    
    # Install essential and (if applicable) developer packages
    install_minimum
    
    # Run post-installation tasks
    post_installation
}

# Run main function
main "$@"

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
    echo "    ██████╗ ██╗ ██████╗███████╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
    echo "    ██╔══██╗██║██╔════╝██╔════╝    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
    echo "    ██████╔╝██║██║     █████╗      ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ "
    echo "    ██╔══██╗██║██║     ██╔══╝      ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ "
    echo "    ██║  ██║██║╚██████╗███████╗    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
    echo "    ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"
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
        print_info "Standard user profile - focusing on essential packages"
    fi
    echo ""
}

# Installation function with improved error handling
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
        
        for package in "${packages[@]}"; do
            current=$((current + 1))
            echo -e "${BLUE}[$current/$total]${NC} Installing $package..."
            
            if ! yay -S --needed --noconfirm "$package" 2>/dev/null; then
                print_warning "Failed to install $package, continuing..."
            fi
        done
        
        print_success "$description installed successfully"
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
    if ask_yes_no "Update system before installation?"; then
        print_info "Updating system..."
        yay -Syu --noconfirm
        print_success "System updated"
    fi
    echo ""
}

# Package definitions optimized for rice
declare -A PACKAGES

# Essential packages for rice functionality
PACKAGES["essential"]="sway swaybg swaylock-effects swayidle hyprland hyprpaper hyprlock hypridle hyprsunset waybar wofi mako fastfetch foot kitty ghostty neovim git curl vim rsync bc libnotify brightnessctl playerctl htop bat eza tree yazi galculator clipman tgpt yt-dlp hyperfine slurp grim wl-clipboard"

# Themes and fonts for rice
PACKAGES["rice_theme"]="adapta-gtk-theme orchis-theme kvantum lxappearance ttf-jetbrains-mono-nerd ttf-fira-code adobe-source-code-pro-fonts"

# Developer essentials (if developer profile)
PACKAGES["dev_essential"]="github-cli  nodejs pnpm npm python python-pip cargo rust go onefetch cloc typescript lazygit "

# Multimedia and appearance
PACKAGES["multimedia"]="pavucontrol clapper viewnior gst-plugin-bad gst-plugin-ugly gst-libav"

# Development extras
PACKAGES["dev_extras"]="docker docker-compose podman composer uv ts-node sccache lazydocker-bin croc"


# Personal tools
PACKAGES["personal"]="cloudflare-warp-bin google-cloud-cli obsidian thorium-browser-bin drawio-desktop brave-bin telegram-desktop yq appflowy-bin  macchanger megasync-bin turso"


# All remaining packages
PACKAGES["extras"]="freedownloadmanager firefox gpu-screen-recorder-gtk pipes.sh onlyoffice-bin atril cheese qemu meld"

# Installation profiles
install_minimum() {
    print_header "MINIMUM DEPENDENCIES INSTALLATION"
    print_info "Installing essential packages for rice functionality"
    
    # Always install essential packages
    IFS=' ' read -ra packages <<< "${PACKAGES[essential]}"
    install_packages "essential" "Essential Rice Packages" "${packages[@]}"
    
    # Add developer tools if developer profile
    if [ "$IS_DEVELOPER" = true ]; then
        IFS=' ' read -ra dev_packages <<< "${PACKAGES[dev_essential]}"
        install_packages "dev_essential" "Essential Developer Tools" "${dev_packages[@]}"
    fi
    
    # Rice theming
    IFS=' ' read -ra theme_packages <<< "${PACKAGES[rice_theme]}"
    install_packages "rice_theme" "Rice Themes and Fonts" "${theme_packages[@]}"
    
    
    # Basic multimedia
    IFS=' ' read -ra multimedia_packages <<< "${PACKAGES[multimedia]}"
    install_packages "multimedia" "Basic Multimedia Tools" "${multimedia_packages[@]}"
}

install_all() {
    print_header "COMPLETE INSTALLATION"
    print_info "Installing all available packages"
    
    for category in essential dev_essential rice_theme  multimedia  dev_extras personal  extras; do
        if [[ -v PACKAGES[$category] ]]; then
            IFS=' ' read -ra packages <<< "${PACKAGES[$category]}"
            # Create readable category names
            case $category in
                essential) description="Essential Rice Packages" ;;
                dev_essential) description="Essential Developer Tools" ;;
                rice_theme) description="Rice Themes and Fonts" ;;
                multimedia) description="Multimedia Applications" ;;
                dev_extras) description="Development Tools" ;;
                personal) description="Personal Tools" ;;
                extras) description="Extra Utilities" ;;
            esac
            install_packages "$category" "$description" "${packages[@]}"
        fi
    done
}

install_by_category() {
    print_header "SELECTIVE INSTALLATION"
    print_info "Choose categories to install:"
    echo ""
    
    echo "Available categories:"
    echo "1.  Essential Rice Packages (${PACKAGES[essential]})"
    echo "2.  Essential Developer Tools (${PACKAGES[dev_essential]})"
    echo "3.  Rice Themes and Fonts (${PACKAGES[rice_theme]})"
    echo "4.  Multimedia Applications (${PACKAGES[multimedia]})"
    echo "5.  Development Tools (${PACKAGES[dev_extras]})"
    echo "6.  Personal Tools (${PACKAGES[personal]})"
    echo "7.  Extra Utilities (${PACKAGES[extras]})"
    echo ""
    
    declare -A category_map
    category_map[1]="essential"
    category_map[2]="dev_essential"
    category_map[3]="rice_theme"
    category_map[4]="multimedia"
    category_map[5]="dev_extras"
    category_map[6]="personal"
    category_map[7]="extras"
    
    declare -A category_descriptions
    category_descriptions["essential"]="Essential Rice Packages"
    category_descriptions["dev_essential"]="Essential Developer Tools"
    category_descriptions["rice_theme"]="Rice Themes and Fonts"
    category_descriptions["multimedia"]="Multimedia Applications"
    category_descriptions["dev_extras"]="Development Tools"
    category_descriptions["personal"]="Personal Tools"
    category_descriptions["extras"]="Extra Utilities"
    
    while true; do
        read -p "$(echo -e "${YELLOW}Enter category numbers (e.g., 1 3 5), 'all' for everything, or 'done' to finish: ${NC}")" selected
        
        if [[ "$selected" == "done" ]]; then
            break
        elif [[ "$selected" == "all" ]]; then
            install_all
            break
        else
            for num in $selected; do
                if [[ -v category_map[$num] ]]; then
                    category_key="${category_map[$num]}"
                    IFS=' ' read -ra packages <<< "${PACKAGES[$category_key]}"
                    install_packages "$category_key" "${category_descriptions[$category_key]}" "${packages[@]}"
                else
                    print_error "Invalid category number: $num"
                fi
            done
        fi
    done
}

# Post-installation configuration
# User applications
post_installation() {
    print_header "Post-Installation Configuration"
    
    # Docker configuration
    if command -v docker &> /dev/null; then
        if ask_yes_no "Add user to docker group?"; then
            sudo usermod -aG docker "$USER"
            print_success "User added to docker group"
            print_warning "Log out and back in for docker group changes to take effect"
        fi
    fi
    
    # Enable services
    print_info "Enabling essential services..."
    if command -v NetworkManager &> /dev/null; then
        sudo systemctl enable NetworkManager
        print_success "NetworkManager enabled"
    fi
    
    
    print_header "Installation Summary"
    echo -e "🎉 All packages installed successfully! \n"
}

# Main script execution
main() {
    clear
    print_logo
    
    print_info "Welcome to the Arch Linux Rice Installation Script"
    print_info "This script will install packages optimized for Sway/Hyprland rice"
    echo ""
    
    check_prerequisites
    check_developer_profile
    
    while true; do
        print_header "Installation Options"
        echo "1. 🟢 Install Minimum Dependencies (Essential rice packages)"
        if [ "$IS_DEVELOPER" = true ]; then
            echo "   └── Includes developer tools (detected developer profile)"
        fi
        echo "2. 🔵 Install All Packages (Complete installation)"
        echo "3. 🟡 Install by Category (Selective installation)"
        echo "4. ❌ Exit"
        echo ""
        
        read -p "$(echo -e "${YELLOW}Choose an option (1-4): ${NC}")" choice
        
        case $choice in
            1)
                install_minimum
                post_installation
                break
                ;;
            2)
                install_all
                post_installation
                break
                ;;
            3)
                install_by_category
                post_installation
                break
                ;;
            4)
                print_info "Installation cancelled"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please choose 1-4."
                ;;
        esac
    done
}

# Run main function
main "$@"

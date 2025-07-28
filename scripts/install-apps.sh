#!/bin/bash

# Interactive application installation script for Arch Linux
# Based on your existing configuration with categories

set -e

# Colors for display
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
            * ) echo "Please answer with y (yes) or n (no).";;
        esac
    done
}

# Installation function with error handling
install_packages() {
    local category="$1"
    shift
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        print_warning "No packages to install for $category"
        return
    fi
    
    print_header "Installation: $category"
    echo "Packages to install: ${packages[*]}"
    
    if ask_yes_no "Continue with installation of $category ?"; then
        echo "📦 Installation in progress..."
        if yay -S --needed --noconfirm "${packages[@]}"; then
            print_success "$category installed successfully"
        else
            print_error "Error during installation of $category"
            if ask_yes_no "Continue despite the error?"; then
                return 0
            else
                exit 1
            fi
        fi
    else
        print_info "$category skipped"
    fi
}

# Prerequisites check
print_header "Prerequisites check"

if ! command -v yay &> /dev/null; then
    print_error "yay is not installed. Installation required."
    if ask_yes_no "Install yay now?"; then
        sudo pacman -S --needed base-devel git
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
    else
        exit 1
    fi
fi

print_success "yay is available"

# System update
if ask_yes_no "Update the system before installation?"; then
    print_header "System update"
    yay -Syu --noconfirm
    print_success "System updated"
fi

# Definition of categories and packages
declare -A CATEGORIES

# 1. Base system packages
CATEGORIES["base"]="debugedit freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu"

# 2. Editors and IDEs
CATEGORIES["editors"]="code neovim zed nano vim"

# 3. Terminals
CATEGORIES["terminals"]="ghostty kitty foot"

# 4. CLI development tools
CATEGORIES["dev_tools"]="github-cli glab lazygit cargo-tauri composer pnpm uv ts-node sccache bc lazydocker-bingo rust nodejs php"

# 5. System and monitoring tools
CATEGORIES["system_tools"]="htop fastfetch bat eza tree hyperfine onefetch cloc yazi rsync wget croc tgpt gpu-screen-recorder-gtk pipes.sh clipman"

# 6. Containerization
CATEGORIES["containers"]="docker docker-compose podman qemu"

# 7. Graphical development applications
CATEGORIES["dev_apps"]="zeal"

# 8. Sway/Wayland Environment
CATEGORIES["sway"]="sway wofi slurp wlsunset"

# 9. Hyprland
CATEGORIES["hyprland"]="hyprland hyprlock hyprpaper hyprsunset"

# 10. X Server (for compatibility)
CATEGORIES["xorg"]="xorg-server xorg-xinit xf86-video-amdgpu xf86-video-ati"

# 11. Themes and appearance
CATEGORIES["themes"]="adapta-gtk-theme orchis-theme kvantum lxappearance"

# 12. Fonts
CATEGORIES["fonts"]="adobe-source-code-pro-fonts ttf-fira-code ttf-fira-sans ttf-hack ttf-jetbrains-mono-nerd ttf-ubuntu-font-family"

# 13. Multimedia applications
CATEGORIES["multimedia"]="vlc clapper cheese viewnior pavucontrol"

# 14. User applications
CATEGORIES["user_apps"]="firefox telegram-desktop galculator atril yt-dlp   onlyoffice-bin"

# 15. Network and security tools
CATEGORIES["network"]="macchanger wireless_tools wpa_supplicant iwgtk"

# 16. Miscellaneous utilities
CATEGORIES["utilities"]="yq freedownloadmanager"

# 17. For me
CATEGORIES["me"]="cloudflare-warp-bin  google-cloud-cli turso obsidian appflowy-bin thorium-browser-bin drawio-desktop megasync-bin brave-bin"

# Interactive main menu
print_header "Interactive Arch Linux Installation Script"
echo "This script will install applications by categories."
echo "You can choose to install all categories automatically or select them individually."
echo ""

if ask_yes_no "Do you want to install ALL categories automatically?"; then
    # Automatic installation of everything
    for category in "${!CATEGORIES[@]}"; do
        IFS=' ' read -ra packages <<< "${CATEGORIES[$category]}"
        install_packages "$category" "${packages[@]}"
    done
else
    # Selective installation
    echo ""
    print_info "Selective installation - choose your categories:"
    echo ""
    
    # Display menu
    echo "Available categories:"
    echo "1.  Base system (${CATEGORIES[base]})"
    echo "2.  Editors (${CATEGORIES[editors]})"
    echo "3.  Terminals (${CATEGORIES[terminals]})"
    echo "4.  CLI Development Tools (${CATEGORIES[dev_tools]})"
    echo "5.  System Tools (${CATEGORIES[system_tools]})"
    echo "6.  Containerization (${CATEGORIES[containers]})"
    echo "7.  Graphical Development Apps (${CATEGORIES[dev_apps]})"
    echo "8.  Sway Environment (${CATEGORIES[sway]})"
    echo "9.  Hyprland (${CATEGORIES[hyprland]})"
    echo "10. X Server (${CATEGORIES[xorg]})"
    echo "11. Themes and Appearance (${CATEGORIES[themes]})"
    echo "12. Fonts (${CATEGORIES[fonts]})"
    echo "13. Multimedia (${CATEGORIES[multimedia]})"
    echo "14. User Applications (${CATEGORIES[user_apps]})"
    echo "15. Network and Security (${CATEGORIES[network]})"
    echo "16. Miscellaneous Utilities (${CATEGORIES[utilities]})"
    echo ""
    
    # Installation by category
    declare -A category_map
    category_map[1]="base"
    category_map[2]="editors"
    category_map[3]="terminals"
    category_map[4]="dev_tools"
    category_map[5]="system_tools"
    category_map[6]="containers"
    category_map[7]="dev_apps"
    category_map[8]="sway"
    category_map[9]="hyprland"
    category_map[10]="xorg"
    category_map[11]="themes"
    category_map[12]="fonts"
    category_map[13]="multimedia"
    category_map[14]="user_apps"
    category_map[15]="network"
    category_map[16]="utilities"
    
    for i in {1..16}; do
        category_key="${category_map[$i]}"
        IFS=' ' read -ra packages <<< "${CATEGORIES[$category_key]}"
        install_packages "Category $i: $category_key" "${packages[@]}"
    done
fi

# Post-installation configuration
print_header "Post-installation configuration"

if ask_yes_no "Configure Docker for the current user?"; then
    print_info "Configuring Docker..."
    sudo usermod -aG docker $USER
    print_success "User added to docker group"
    print_warning "Restart your session for changes to take effect"
fi

print_header "Installation complete!"
print_success "Your Arch Linux environment is configured"
echo ""
print_info "Important notes:"
echo "   - Restart your session for groups to take effect"
echo "   - Configure your Sway/Hyprland environment according to your preferences"  
echo "   - Nerd fonts are installed for a better terminal experience"
echo ""
print_success "🎉 Installation completed successfully!"

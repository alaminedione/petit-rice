#!/bin/bash

# Automatic installation script for personal and extra applications
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

    echo "📦 Installing packages..."

    local total=${#packages[@]}
    local current=0
    local failed_packages=()

    for package in "${packages[@]}"; do
        current=$((current + 1))
        echo -e "${BLUE}[$current/$total]${NC} Installing $package..."

        if ! yay -S --needed --noconfirm "$package"; then
            print_error "Initial installation of $package failed."
            if ask_yes_no "Do you want to try reinstalling $package?"; then
                if yay -S --needed --noconfirm "$package"; then
                    print_success "$package reinstalled successfully."
                else
                    failed_packages+=("$package")
                    print_error "Failed to install $package after retry, continuing..."
                fi
            else
                failed_packages+=("$package")
                print_info "Skipping $package as requested, continuing..."
            fi
        fi
    done

    if [ ${#failed_packages[@]} -eq 0 ]; then
        print_success "$description installed successfully"
    else
        print_warning "$description partially installed. Failed packages: ${failed_packages[*]}"
    fi
    echo ""
}

# Package definitions
declare -A PACKAGES
PACKAGES["extras"]="freedownloadmanager firefox gpu-screen-recorder-gtk pipes.sh onlyoffice-bin atril cheese meld clapper viewnior gst-plugin-bad gst-plugin-ugly gst-libav zeal"
PACKAGES["personal"]="cloudflare-warp-bin  drawio-desktop brave-bin telegram-desktop   macchanger megasync-bin turso docker docker-compose podman podman-compose podman-desktop"

# Main script execution
main() {
    print_header "Personal & Extra Apps Installation"

    # Prerequisites check
    if ! command -v yay &> /dev/null; then
        print_error "'yay' is not installed. Please run the main installer first or install yay manually."
        exit 1
    fi
    if ! ping -c 1 archlinux.org &> /dev/null; then
        print_error "No internet connection detected."
        exit 1
    fi

    print_info "This script will install 'Extra Utilities' and 'Personal Tools'."
    if ! ask_yes_no "Do you want to proceed with the installation?"; then
        print_info "Installation cancelled."
        exit 0
    fi

    IFS=' ' read -ra extras_packages <<< "${PACKAGES[extras]}"
    install_packages "extras" "Extra Utilities" "${extras_packages[@]}"

    IFS=' ' read -ra personal_packages <<< "${PACKAGES[personal]}"
    install_packages "personal" "Personal Tools" "${personal_packages[@]}"

    # Docker post-install
    if command -v docker &> /dev/null; then
        if ask_yes_no "Add user to docker group?"; then
            sudo usermod -aG docker "$USER"
            print_success "User added to docker group"
            print_warning "Log out and back in for docker group changes to take effect"
        fi
    fi

    print_header "Installation Summary"
    echo -e "🎉 All selected personal and extra packages have been processed! 
"
}

main "$@"

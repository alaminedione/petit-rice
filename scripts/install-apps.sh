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
PACKAGES["essential"]="debugedit sway swaybg swaylock-effects swayidle hyprland hyprpaper hyprlock hypridle hyprsunset waybar wofi mako fastfetch foot kitty ghostty neovim git curl vim rsync bc libnotify brightnessctl playerctl htop bat fd eza tree yazi zoxide galculator clipman tgpt yt-dlp hyperfine slurp grim wl-clipboard adapta-gtk-theme orchis-theme kvantum lxappearance ttf-jetbrains-mono-nerd ttf-fira-code adobe-source-code-pro-fonts yq wireplumber pavucontrol tumbler  ffmpegthumbnailer  gtk-engine-murrine"

# Developer essentials (if developer profile)
PACKAGES["dev"]="github-cli  nodejs pnpm npm python python-pip cargo rust go onefetch cloc typescript lazygit sccache ccache uv ts-node lazydocker-bin croc php composer"


# Personal tools 
PACKAGES["personal"]="cloudflare-warp-bin google-cloud-cli obsidian thorium-browser-bin drawio-desktop brave-bin telegram-desktop  appflowy-bin  macchanger megasync-bin turso docker docker-compose podman"


# All remaining packages
PACKAGES["extras"]="freedownloadmanager firefox gpu-screen-recorder-gtk pipes.sh onlyoffice-bin atril cheese qemu meld clapper viewnior gst-plugin-bad gst-plugin-ugly gst-libav"

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

install_all() {
    print_header "COMPLETE INSTALLATION: categories: essential, dev, extras"
    print_info "Installing all available packages"
    
    for category in essential dev extras; do
        if [[ -v PACKAGES[$category] ]]; then
            IFS=' ' read -ra packages <<< "${PACKAGES[$category]}"
            # Create readable category names
            case $category in
                essential) description="Essential Rice Packages" ;;
                dev) description="Essential Developer Tools" ;;
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
    echo "2.  Essential Developer Tools (${PACKAGES[dev]})"
    echo "3.  Extra Utilities (${PACKAGES[extras]})"
    echo "4.  Personal Tools (${PACKAGES[personal]})"
    echo ""
    
    declare -A category_map
    category_map[1]="essential"
    category_map[2]="dev"
    category_map[3]="extras"
    category_map[4]="personal"
    
    declare -A category_descriptions
    category_descriptions["essential"]="Essential Rice Packages"
    category_descriptions["dev"]="Development tools"
    category_descriptions["extras"]="Extra Utilities"
    category_descriptions["personal"]="Personal Tools"
    
    while true; do
        read -p "$(echo -e "${YELLOW}Enter category numbers (e.g., 1 2 3), 'all' for everything, or 'done' to finish: ${NC}")" selected
        
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
    
    print_header "Installation Summary"
    echo -e "🎉 All packages installed successfully! \n"
}

# Main script execution
main() {
    clear
    print_logo
    
    print_info "Welcome to the Arch Linux Rice Installation Script"
    print_info "This script will install packages for Sway/Hyprland rice"
    echo ""
    
    check_prerequisites
    check_developer_profile
    
    while true; do
        print_header "Installation Options"
        print_info "Available Categories: essential, dev, personal, extras"
        echo "1. 🟢 Install Minimum Dependencies:"
        echo "   - Core packages for this Sway/Hyprland desktop rice (window managers, bar, launcher, terminal, basic utilities)."
        if [ "$IS_DEVELOPER" = true ]; then
            echo "   - Includes essential developer tools as developer profile was detected."
        fi
        echo "2. 🔵 Install All Packages (excluding category: personal):"
        echo "   - A complete installation including essential, developer, and extra utility packages (general-purpose tools: browser, media player, document reader...)."
        echo "3. 🟡 Install by Category:"
        echo "   - Allows you to selectively choose which groups of packages (essential, dev, personal, extras) to install."
        echo "4. ❌ Cancel Installation:"
        echo "   - Exit the script without installing any packages."
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

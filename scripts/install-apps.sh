#!/bin/bash

# Script d'installation interactive des applications pour Arch Linux
# Basé sur votre configuration existante avec des catégories

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction d'affichage coloré
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

# Fonction pour demander confirmation
ask_yes_no() {
    while true; do
        read -p "$(echo -e "${YELLOW}$1 (y/n): ${NC}")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Veuillez répondre par y (oui) ou n (non).";;
        esac
    done
}

# Fonction d'installation avec gestion d'erreurs
install_packages() {
    local category="$1"
    shift
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        print_warning "Aucun package à installer pour $category"
        return
    fi
    
    print_header "Installation: $category"
    echo "Packages à installer: ${packages[*]}"
    
    if ask_yes_no "Continuer l'installation de $category ?"; then
        echo "📦 Installation en cours..."
        if yay -S --needed --noconfirm "${packages[@]}"; then
            print_success "$category installé avec succès"
        else
            print_error "Erreur lors de l'installation de $category"
            if ask_yes_no "Continuer malgré l'erreur ?"; then
                return 0
            else
                exit 1
            fi
        fi
    else
        print_info "$category ignoré"
    fi
}

# Vérification des prérequis
print_header "Vérification des prérequis"

if ! command -v yay &> /dev/null; then
    print_error "yay n'est pas installé. Installation requise."
    if ask_yes_no "Installer yay maintenant ?"; then
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

print_success "yay est disponible"

# Mise à jour du système
if ask_yes_no "Mettre à jour le système avant l'installation ?"; then
    print_header "Mise à jour du système"
    yay -Syu --noconfirm
    print_success "Système mis à jour"
fi

# Définition des catégories et packages
declare -A CATEGORIES

# 1. Packages de base système
CATEGORIES["base"]="debugedit freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu"

# 2. Éditeurs et IDEs
CATEGORIES["editors"]="code neovim zed nano vim"

# 3. Terminaux
CATEGORIES["terminals"]="ghostty kitty foot"

# 4. Outils de développement CLI
CATEGORIES["dev_tools"]="github-cli glab lazygit cargo-tauri composer pnpm uv ts-node sccache bc lazydocker-bin"

# 5. Outils système et monitoring
CATEGORIES["system_tools"]="htop fastfetch bat eza tree hyperfine onefetch cloc yazi rsync wget croc tgpt gpu-screen-recorder-gtk pipes.sh"

# 6. Containerisation
CATEGORIES["containers"]="docker docker-compose podman qemu"

# 7. Applications graphiques de développement
CATEGORIES["dev_apps"]="zeal"

# 8. Environnement Sway/Wayland
CATEGORIES["sway"]="sway wofi slurp wlsunset"

# 9. Hyprland
CATEGORIES["hyprland"]="hyprland hyprlock hyprpaper hyprsunset"

# 10. Serveur X (pour compatibilité)
CATEGORIES["xorg"]="xorg-server xorg-xinit xf86-video-amdgpu xf86-video-ati"

# 11. Thèmes et apparence
CATEGORIES["themes"]="adapta-gtk-theme orchis-theme kvantum lxappearance"

# 12. Polices
CATEGORIES["fonts"]="adobe-source-code-pro-fonts ttf-fira-code ttf-fira-sans ttf-hack ttf-jetbrains-mono-nerd ttf-ubuntu-font-family"

# 13. Applications multimédia
CATEGORIES["multimedia"]="vlc clapper cheese viewnior pavucontrol"

# 14. Applications utilisateur
CATEGORIES["user_apps"]="firefox telegram-desktop galculator atril yt-dlp   onlyoffice-bin"

# 15. Outils réseau et sécurité
CATEGORIES["network"]="macchanger wireless_tools wpa_supplicant iwgtk"

# 16. Utilitaires divers
CATEGORIES["utilities"]="yq freedownloadmanager"

# 17. for me
CATEGORIES["me"]="cloudflare-warp-bin  google-cloud-cli turso obsidian appflowy-bin thorium-browser-bin drawio-desktop megasync-bin brave-bin"

# Menu principal interactif
print_header "Script d'installation interactive Arch Linux"
echo "Ce script installera les applications par catégories."
echo "Vous pouvez choisir d'installer toutes les catégories ou sélectionner individuellement."
echo ""

if ask_yes_no "Voulez-vous installer TOUTES les catégories automatiquement ?"; then
    # Installation automatique de tout
    for category in "${!CATEGORIES[@]}"; do
        IFS=' ' read -ra packages <<< "${CATEGORIES[$category]}"
        install_packages "$category" "${packages[@]}"
    done
else
    # Installation sélective
    echo ""
    print_info "Installation sélective - choisissez vos catégories:"
    echo ""
    
    # Affichage du menu
    echo "Catégories disponibles:"
    echo "1.  Base système (${CATEGORIES[base]})"
    echo "2.  Éditeurs (${CATEGORIES[editors]})"
    echo "3.  Terminaux (${CATEGORIES[terminals]})"
    echo "4.  Outils développement CLI (${CATEGORIES[dev_tools]})"
    echo "5.  Outils système (${CATEGORIES[system_tools]})"
    echo "6.  Containerisation (${CATEGORIES[containers]})"
    echo "7.  Apps développement graphiques (${CATEGORIES[dev_apps]})"
    echo "8.  Environnement Sway (${CATEGORIES[sway]})"
    echo "9.  Hyprland (${CATEGORIES[hyprland]})"
    echo "10. Serveur X (${CATEGORIES[xorg]})"
    echo "11. Thèmes et apparence (${CATEGORIES[themes]})"
    echo "12. Polices (${CATEGORIES[fonts]})"
    echo "13. Multimédia (${CATEGORIES[multimedia]})"
    echo "14. Applications utilisateur (${CATEGORIES[user_apps]})"
    echo "15. Réseau et sécurité (${CATEGORIES[network]})"
    echo "16. Utilitaires divers (${CATEGORIES[utilities]})"
    echo ""
    
    # Installation par catégorie
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
        install_packages "Catégorie $i: $category_key" "${packages[@]}"
    done
fi

# Configuration post-installation
print_header "Configuration post-installation"

if ask_yes_no "Configurer Docker pour l'utilisateur actuel ?"; then
    print_info "Configuration de Docker..."
    sudo usermod -aG docker $USER
    print_success "Utilisateur ajouté au groupe docker"
    print_warning "Redémarrez votre session pour que les changements prennent effet"
fi

print_header "Installation terminée !"
print_success "Votre environnement Arch Linux est configuré"
echo ""
print_info "Notes importantes:"
echo "   - Redémarrez votre session pour que les groupes prennent effet"
echo "   - Configurez votre environnement Sway/Hyprland selon vos préférences"  
echo "   - Les polices Nerd sont installées pour une meilleure expérience terminal"
echo ""
print_success "🎉 Installation terminée avec succès!"

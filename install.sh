#!/bin/bash

# Script d'installation automatique des dotfiles
# Ce script permet de configurer automatiquement les thèmes et configurations

set -e

# Couleurs pour l'affichage
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

# Fonction de sauvegarde globale
create_global_backup() {
    local apps=("foot" "kitty" "nvim" "sway" "swaylock" "waybar" "wofi" "mako" "fastfetch" "hypr")
    local backup_needed=false
    
    print_info "Vérification des configurations existantes..."
    
    # Vérifier s'il y a des configurations à sauvegarder
    for app in "${apps[@]}"; do
        local config_path="$CONFIG_DIR/$app"
        if [ -d "$config_path" ] || [ -f "$config_path" ]; then
            backup_needed=true
            break
        fi
    done
    
    # Vérifier les scripts hotfiles existants
    if [ -d "$CONFIG_DIR/hotfiles-scripts" ]; then
        backup_needed=true
    fi
    
    if [ "$backup_needed" = true ]; then
        print_info "Création du dossier de sauvegarde global: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        
        # Créer un fichier d'information sur la sauvegarde
        cat > "$BACKUP_DIR/backup-info.txt" << EOF
Sauvegarde créée le: $(date)
Timestamp: $TIMESTAMP
Script utilisé: $0
Répertoire source: $SCRIPT_DIR
Configurations sauvegardées:
EOF
        
        # Sauvegarder chaque configuration existante
        for app in "${apps[@]}"; do
            local config_path="$CONFIG_DIR/$app"
            if [ -d "$config_path" ] || [ -f "$config_path" ]; then
                print_info "Sauvegarde de $app..."
                cp -r "$config_path" "$BACKUP_DIR/$app"
                echo "  - $app" >> "$BACKUP_DIR/backup-info.txt"
                print_success "✓ $app sauvegardé"
            fi
        done
        
        # Sauvegarder les scripts hotfiles s'ils existent
        if [ -d "$CONFIG_DIR/hotfiles-scripts" ]; then
            print_info "Sauvegarde des scripts hotfiles..."
            cp -r "$CONFIG_DIR/hotfiles-scripts" "$BACKUP_DIR/hotfiles-scripts"
            echo "  - hotfiles-scripts" >> "$BACKUP_DIR/backup-info.txt"
            print_success "✓ Scripts hotfiles sauvegardés"
        fi
        
        print_success "Sauvegarde globale créée: $BACKUP_DIR"
        echo -e "${GREEN}📁 Sauvegarde disponible pour restauration avec: ./restore.sh $TIMESTAMP${NC}"
    else
        print_info "Aucune configuration existante trouvée, pas de sauvegarde nécessaire"
    fi
}

# Fonction d'installation des configurations
install_config() {
    local app_name="$1"
    local source_dir="$SCRIPT_DIR/$app_name"
    local target_dir="$CONFIG_DIR/$app_name"
    
    if [ -d "$source_dir" ]; then
        print_info "Installation de la configuration $app_name..."
        
        # Création du répertoire cible
        mkdir -p "$(dirname "$target_dir")"
        
        # Suppression de l'ancienne configuration si elle existe
        if [ -d "$target_dir" ] || [ -f "$target_dir" ]; then
            rm -rf "$target_dir"
        fi
        
        # Copie des fichiers
        cp -r "$source_dir" "$target_dir"
        print_success "Configuration $app_name installée"
    else
        print_warning "Configuration $app_name non trouvée dans $source_dir"
    fi
}

# Fonction pour rendre les scripts exécutables
make_scripts_executable() {
    print_info "Rendement des scripts exécutables..."
    find "$SCRIPT_DIR/scripts" -name "*.sh" -type f -exec chmod +x {} \;
    print_success "Scripts rendus exécutables"
}

# Fonction principale d'installation
main_install() {
    print_header "Installation des dotfiles"
    
    # Vérification des prérequis
    if [ ! -d "$SCRIPT_DIR" ]; then
        print_error "Répertoire source non trouvé: $SCRIPT_DIR"
        exit 1
    fi
    
    # Création du répertoire de sauvegarde de base
    mkdir -p "$BACKUP_BASE_DIR"
    
    # Création de la sauvegarde globale AVANT l'installation
    create_global_backup
    
    # Liste des applications à configurer
    local apps=("foot" "kitty" "nvim" "sway" "swaylock" "waybar" "wofi" "mako" "fastfetch")
    
    # Installation des configurations
    for app in "${apps[@]}"; do
        install_config "$app"
    done
    
    # Gestion spéciale pour hypr (si présent)
    if [ -d "$SCRIPT_DIR/hypr" ]; then
        install_config "hypr"
    fi
    
    # Rendre les scripts exécutables
    make_scripts_executable
    
    # Copie des scripts dans un répertoire accessible
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        print_info "Installation des scripts utilitaires..."
        mkdir -p "$CONFIG_DIR/hotfiles-scripts"
        cp -r "$SCRIPT_DIR/scripts"/* "$CONFIG_DIR/hotfiles-scripts/"
        print_success "Scripts utilitaires installés dans $CONFIG_DIR/hotfiles-scripts/"
    fi
}

# Fonction d'installation des dépendances
install_dependencies() {
    print_header "Installation des dépendances"
    
    if [ -f "$SCRIPT_DIR/scripts/install-apps.sh" ]; then
        if ask_yes_no "Voulez-vous installer les applications nécessaires ?"; then
            print_info "Lancement du script d'installation des applications..."
            bash "$SCRIPT_DIR/scripts/install-apps.sh"
        fi
    else
        print_warning "Script d'installation des applications non trouvé"
    fi
}

# Fonction d'application du thème par défaut
apply_default_theme() {
    print_header "Application du thème par défaut"
    
    if [ -f "$SCRIPT_DIR/scripts/change-theme/set-mocha.sh" ]; then
        if ask_yes_no "Voulez-vous appliquer le thème Catppuccin Mocha (thème par défaut) ?"; then
            print_info "Application du thème Catppuccin Mocha..."
            bash "$SCRIPT_DIR/scripts/change-theme/set-mocha.sh"
            print_success "Thème Catppuccin Mocha appliqué"
        fi
    else
        print_warning "Script de thème par défaut non trouvé"
    fi
}

# Fonction d'exécution des scripts de configuration supplémentaires
run_additional_scripts() {
    print_header "Scripts de configuration supplémentaires"
    
    # Scripts optionnels
    local optional_scripts=(
        "scripts/fix_fonts.sh:Correction des polices"
        "scripts/gsettings.sh:Configuration des paramètres GNOME"
        "scripts/get-layan-cursors.sh:Installation des curseurs Layan"
        "scripts/config-zsh.sh:Configuration de Zsh"
        "scripts/config-vim.sh:Configuration de Vim"
        "scripts/set-swapinness.sh:Configuration du swapinness"
        "scripts/create_macspoof_service.sh:Création du service macspoof pour le spoofing de l'adresse MAC"
    )
    
    for script_info in "${optional_scripts[@]}"; do
        IFS=':' read -ra SCRIPT_PARTS <<< "$script_info"
        local script_path="$SCRIPT_DIR/${SCRIPT_PARTS[0]}"
        local script_desc="${SCRIPT_PARTS[1]}"
        
        if [ -f "$script_path" ]; then
            if ask_yes_no "Exécuter: $script_desc ?"; then
                print_info "Exécution de $script_desc..."
                bash "$script_path"
                print_success "$script_desc terminé"
            fi
        fi
    done
}

# Fonction d'affichage du résumé
show_summary() {
    print_header "Résumé de l'installation"
    
    echo -e "${GREEN}✅ Installation terminée avec succès !${NC}"
    echo ""
    print_info "Configurations installées dans: $CONFIG_DIR"
    if [ -d "$BACKUP_DIR" ]; then
        print_info "Sauvegarde créée dans: $BACKUP_DIR"
        print_info "Pour restaurer cette sauvegarde: ./restore.sh $TIMESTAMP"
    fi
    print_info "Scripts utilitaires dans: $CONFIG_DIR/hotfiles-scripts"
    echo ""
    print_warning "Actions recommandées:"
    echo "   - Redémarrez votre session pour appliquer tous les changements"
    echo "   - Vérifiez les configurations dans vos applications"
    echo "   - Utilisez les scripts de changement de thème si nécessaire"
    echo ""
    print_info "Scripts de thème disponibles:"
    if [ -d "$SCRIPT_DIR/scripts/change-theme" ]; then
        find "$SCRIPT_DIR/scripts/change-theme" -name "*.sh" -exec basename {} \; | sed 's/^/   - /'
    fi
    echo ""
    print_info "Sauvegardes disponibles:"
    if [ -d "$BACKUP_BASE_DIR" ]; then
        ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | sed 's/^backup-/   - /' | sed 's/$/ (utilisez: .\/restore.sh <timestamp>)/'
    fi
}

# Menu principal
show_menu() {
    print_header "Script d'installation des dotfiles"
    echo "Ce script va configurer automatiquement vos dotfiles."
    echo ""
    echo "Options disponibles:"
    echo "1. Installation complète (recommandé)"
    echo "2. Installation des configurations seulement"
    echo "3. Installation des dépendances seulement"
    echo "4. Application du thème par défaut seulement"
    echo "5. Quitter"
    echo ""
    
    read -p "$(echo -e "${YELLOW}Choisissez une option (1-5): ${NC}")" choice
    
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
            print_info "Installation annulée"
            exit 0
            ;;
        *)
            print_error "Option invalide"
            show_menu
            ;;
    esac
}

# Point d'entrée principal
main() {
    # Vérification que le script est exécuté depuis le bon répertoire
    if [ ! -f "$SCRIPT_DIR/forge.yaml" ]; then
        print_error "Ce script doit être exécuté depuis le répertoire des dotfiles"
        exit 1
    fi
    
    # Affichage du menu
    show_menu
}

# Exécution du script principal
main "$@"
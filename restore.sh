#!/bin/bash

# Script de restauration des dotfiles
# Ce script permet de restaurer une configuration sauvegardée à un moment donné

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
BACKUP_BASE_DIR="$HOME/.config-backups"
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

# Fonction pour lister les sauvegardes disponibles
list_backups() {
    print_header "Sauvegardes disponibles"
    
    if [ ! -d "$BACKUP_BASE_DIR" ]; then
        print_error "Aucun répertoire de sauvegarde trouvé: $BACKUP_BASE_DIR"
        return 1
    fi
    
    local backups=($(ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | sort -r))
    
    if [ ${#backups[@]} -eq 0 ]; then
        print_error "Aucune sauvegarde trouvée dans $BACKUP_BASE_DIR"
        return 1
    fi
    
    echo "Sauvegardes disponibles:"
    for i in "${!backups[@]}"; do
        local backup="${backups[$i]}"
        local timestamp="${backup#backup-}"
        local backup_path="$BACKUP_BASE_DIR/$backup"
        
        echo -e "${BLUE}$((i+1)). ${NC}$timestamp"
        
        # Afficher les informations de la sauvegarde si disponibles
        if [ -f "$backup_path/backup-info.txt" ]; then
            echo -e "   ${CYAN}Date:${NC} $(grep "Sauvegarde créée le:" "$backup_path/backup-info.txt" | cut -d: -f2-)"
            echo -e "   ${CYAN}Configurations:${NC}"
            grep "  - " "$backup_path/backup-info.txt" | sed 's/^/     /'
        else
            echo -e "   ${CYAN}Contenu:${NC} $(ls -1 "$backup_path" | tr '\n' ' ')"
        fi
        echo ""
    done
    
    return 0
}

# Fonction pour afficher les détails d'une sauvegarde
show_backup_details() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [ ! -d "$backup_path" ]; then
        print_error "Sauvegarde non trouvée: $backup_path"
        return 1
    fi
    
    print_header "Détails de la sauvegarde: $timestamp"
    
    if [ -f "$backup_path/backup-info.txt" ]; then
        cat "$backup_path/backup-info.txt"
    else
        echo "Contenu de la sauvegarde:"
        ls -la "$backup_path"
    fi
    
    echo ""
    print_info "Taille de la sauvegarde: $(du -sh "$backup_path" | cut -f1)"
}

# Fonction pour créer une sauvegarde de sécurité avant restauration
create_safety_backup() {
    local safety_timestamp="$(date +%Y%m%d-%H%M%S)"
    local safety_backup_dir="$BACKUP_BASE_DIR/safety-backup-$safety_timestamp"
    
    print_info "Création d'une sauvegarde de sécurité avant restauration..."
    
    mkdir -p "$safety_backup_dir"
    
    # Créer un fichier d'information
    cat > "$safety_backup_dir/backup-info.txt" << EOF
Sauvegarde de sécurité créée le: $(date)
Timestamp: $safety_timestamp
Créée avant restauration
Configurations sauvegardées:
EOF
    
    local apps=("foot" "kitty" "nvim" "sway" "swaylock" "waybar" "wofi" "mako" "fastfetch" "hypr")
    local backup_created=false
    
    # Sauvegarder les configurations actuelles
    for app in "${apps[@]}"; do
        local config_path="$CONFIG_DIR/$app"
        if [ -d "$config_path" ] || [ -f "$config_path" ]; then
            cp -r "$config_path" "$safety_backup_dir/$app"
            echo "  - $app" >> "$safety_backup_dir/backup-info.txt"
            backup_created=true
        fi
    done
    
    # Sauvegarder les scripts hotfiles
    if [ -d "$CONFIG_DIR/hotfiles-scripts" ]; then
        cp -r "$CONFIG_DIR/hotfiles-scripts" "$safety_backup_dir/hotfiles-scripts"
        echo "  - hotfiles-scripts" >> "$safety_backup_dir/backup-info.txt"
        backup_created=true
    fi
    
    if [ "$backup_created" = true ]; then
        print_success "Sauvegarde de sécurité créée: $safety_backup_dir"
        echo "$safety_timestamp"
    else
        rmdir "$safety_backup_dir" 2>/dev/null || true
        print_info "Aucune configuration actuelle à sauvegarder"
        echo ""
    fi
}

# Fonction principale de restauration
restore_backup() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [ ! -d "$backup_path" ]; then
        print_error "Sauvegarde non trouvée: $backup_path"
        return 1
    fi
    
    print_header "Restauration de la sauvegarde: $timestamp"
    
    # Afficher les détails de la sauvegarde
    show_backup_details "$timestamp"
    
    # Demander confirmation
    if ! ask_yes_no "Voulez-vous vraiment restaurer cette sauvegarde ?"; then
        print_info "Restauration annulée"
        return 0
    fi
    
    # Créer une sauvegarde de sécurité
    local safety_backup_timestamp=$(create_safety_backup)
    
    print_info "Début de la restauration..."
    
    # Restaurer chaque élément de la sauvegarde
    for item in "$backup_path"/*; do
        if [ -d "$item" ] || [ -f "$item" ]; then
            local item_name=$(basename "$item")
            
            # Ignorer le fichier d'information
            if [ "$item_name" = "backup-info.txt" ]; then
                continue
            fi
            
            local target_path="$CONFIG_DIR/$item_name"
            
            print_info "Restauration de $item_name..."
            
            # Supprimer la configuration actuelle si elle existe
            if [ -d "$target_path" ] || [ -f "$target_path" ]; then
                rm -rf "$target_path"
            fi
            
            # Créer le répertoire parent si nécessaire
            mkdir -p "$(dirname "$target_path")"
            
            # Copier la configuration sauvegardée
            cp -r "$item" "$target_path"
            
            print_success "✓ $item_name restauré"
        fi
    done
    
    print_success "Restauration terminée avec succès !"
    
    if [ -n "$safety_backup_timestamp" ]; then
        print_info "Sauvegarde de sécurité disponible: $safety_backup_timestamp"
        print_info "Pour annuler cette restauration: ./restore.sh $safety_backup_timestamp"
    fi
    
    print_warning "Redémarrez votre session pour appliquer tous les changements"
}

# Fonction pour supprimer une sauvegarde
delete_backup() {
    local timestamp="$1"
    local backup_path="$BACKUP_BASE_DIR/backup-$timestamp"
    
    if [ ! -d "$backup_path" ]; then
        print_error "Sauvegarde non trouvée: $backup_path"
        return 1
    fi
    
    show_backup_details "$timestamp"
    
    if ask_yes_no "Voulez-vous vraiment supprimer cette sauvegarde ? Cette action est irréversible."; then
        rm -rf "$backup_path"
        print_success "Sauvegarde $timestamp supprimée"
    else
        print_info "Suppression annulée"
    fi
}

# Fonction pour nettoyer les anciennes sauvegardes
cleanup_old_backups() {
    print_header "Nettoyage des anciennes sauvegardes"
    
    if [ ! -d "$BACKUP_BASE_DIR" ]; then
        print_info "Aucun répertoire de sauvegarde trouvé"
        return 0
    fi
    
    local backups=($(ls -1 "$BACKUP_BASE_DIR" | grep "^backup-\|^safety-backup-" | sort))
    local backup_count=${#backups[@]}
    
    print_info "Nombre total de sauvegardes: $backup_count"
    
    if [ $backup_count -le 5 ]; then
        print_info "Moins de 5 sauvegardes, aucun nettoyage nécessaire"
        return 0
    fi
    
    print_info "Sauvegardes anciennes (plus de 5):"
    local to_delete=(${backups[@]:0:$((backup_count-5))})
    
    for backup in "${to_delete[@]}"; do
        echo "  - $backup"
    done
    
    if ask_yes_no "Voulez-vous supprimer ces anciennes sauvegardes ?"; then
        for backup in "${to_delete[@]}"; do
            rm -rf "$BACKUP_BASE_DIR/$backup"
            print_success "✓ $backup supprimé"
        done
        print_success "Nettoyage terminé"
    else
        print_info "Nettoyage annulé"
    fi
}

# Menu interactif de sélection
interactive_menu() {
    if ! list_backups; then
        return 1
    fi
    
    local backups=($(ls -1 "$BACKUP_BASE_DIR" | grep "^backup-" | sort -r))
    
    echo -e "${YELLOW}Choisissez une sauvegarde à restaurer:${NC}"
    for i in "${!backups[@]}"; do
        local timestamp="${backups[$i]#backup-}"
        echo "$((i+1)). $timestamp"
    done
    echo "$((${#backups[@]}+1)). Annuler"
    echo ""
    
    read -p "$(echo -e "${YELLOW}Votre choix (1-$((${#backups[@]}+1))): ${NC}")" choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#backups[@]} ]; then
        local selected_backup="${backups[$((choice-1))]}"
        local timestamp="${selected_backup#backup-}"
        restore_backup "$timestamp"
    elif [ "$choice" -eq $((${#backups[@]}+1)) ]; then
        print_info "Opération annulée"
    else
        print_error "Choix invalide"
    fi
}

# Fonction d'aide
show_help() {
    echo "Script de restauration des dotfiles"
    echo ""
    echo "Usage:"
    echo "  $0                          - Menu interactif"
    echo "  $0 <timestamp>              - Restaurer une sauvegarde spécifique"
    echo "  $0 list                     - Lister les sauvegardes disponibles"
    echo "  $0 details <timestamp>      - Afficher les détails d'une sauvegarde"
    echo "  $0 delete <timestamp>       - Supprimer une sauvegarde"
    echo "  $0 cleanup                  - Nettoyer les anciennes sauvegardes"
    echo "  $0 help                     - Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $0 20240127-143052          - Restaurer la sauvegarde du 27/01/2024 à 14:30:52"
    echo "  $0 list                     - Voir toutes les sauvegardes"
    echo "  $0 details 20240127-143052  - Voir les détails d'une sauvegarde"
}

# Point d'entrée principal
main() {
    case "${1:-}" in
        "list")
            list_backups
            ;;
        "details")
            if [ -z "$2" ]; then
                print_error "Timestamp requis pour 'details'"
                echo "Usage: $0 details <timestamp>"
                exit 1
            fi
            show_backup_details "$2"
            ;;
        "delete")
            if [ -z "$2" ]; then
                print_error "Timestamp requis pour 'delete'"
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
            # Menu interactif si aucun argument
            print_header "Script de restauration des dotfiles"
            interactive_menu
            ;;
        *)
            # Restaurer une sauvegarde spécifique
            if [[ "$1" =~ ^[0-9]{8}-[0-9]{6}$ ]]; then
                restore_backup "$1"
            else
                print_error "Format de timestamp invalide: $1"
                print_info "Format attendu: YYYYMMDD-HHMMSS (ex: 20240127-143052)"
                show_help
                exit 1
            fi
            ;;
    esac
}

# Exécution du script principal
main "$@"
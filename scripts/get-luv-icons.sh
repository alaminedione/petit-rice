#!/bin/bash
set -e

# Variables
REPO_URL="https://github.com/Nitrux/luv-icon-theme.git"
TEMP_DIR="/tmp/luv-icon-theme"
USER_ICON_DIR="$HOME/.icons"

# Vérifier si le thème d'icônes est déjà installé
if [ -d "$HOME/.icons/Luv/" ] || [ -d "$USER_ICON_DIR/Luv/" ]; then
    echo "Luv icon theme is already installed. Skipping..."
else
    # Télécharger le thème
    echo "Downloading Luv icon theme..."
    git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

    # Créer le dossier d'installation si besoin
    mkdir -p "$USER_ICON_DIR"

    # Copier les fichiers du thème
    cp -r "$TEMP_DIR/Luv" "$USER_ICON_DIR/"

    # Mettre à jour le cache des icônes si possible
    if command -v gtk-update-icon-cache &> /dev/null; then
        gtk-update-icon-cache "$USER_ICON_DIR/Luv" || true
    fi

    # Nettoyer le dossier temporaire
    rm -rf "$TEMP_DIR"

    echo "Luv Icon Theme installed in $USER_ICON_DIR"
fi

#!/bin/bash
set -e

# Installation du thème d'icônes Reversal

REPO_URL="https://github.com/yeyushengfan258/Reversal-icon-theme"
REPO_NAME="Reversal-icon-theme"
ICON_PATHS=("$HOME/.icons" "$HOME/.local/share/icons" "/usr/share/icons")

# Vérifier si le thème est déjà installé
already_installed=false
for path in "${ICON_PATHS[@]}"; do
    if [ -d "$path/Reversal" ] || [ -d "$path/Reversal-dark" ]; then
        echo "Le thème d'icônes Reversal est déjà installé dans $path. Abandon."
        already_installed=true
    fi
done

if [ "$already_installed" = true ]; then
    exit 0
fi

# Créer un dossier temporaire pour le clonage
TMP_DIR=$(mktemp -d)

git clone "$REPO_URL" "$TMP_DIR/$REPO_NAME"

cd "$TMP_DIR/$REPO_NAME"
./install.sh

echo "Installation terminée avec succès."

# Nettoyer le dossier temporaire
rm -rf "$TMP_DIR"

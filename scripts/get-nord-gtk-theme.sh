#!/bin/bash

# URL du repository (à remplacer par l'URL réelle)
REPO_URL=https://github.com/EliverLara/Nordic

# Nom du thème (sera extrait de l'URL)
THEME_NAME=$(basename "$REPO_URL" .git)

# Dossier temporaire pour le clone
TEMP_DIR="/tmp/theme_download_$$"

# Dossier de destination
THEMES_DIR="$HOME/.themes"

# Créer le dossier ~/.themes s'il n'existe pas
if [ ! -d "$THEMES_DIR" ]; then
    echo "Création du dossier ~/.themes..."
    mkdir -p "$THEMES_DIR"
fi

# Cloner le repository dans un dossier temporaire
echo "Téléchargement du thème..."
git clone "$REPO_URL" "$TEMP_DIR"

# Vérifier si le clone a réussi
if [ $? -eq 0 ]; then
    # Copier le thème dans ~/.themes
    echo "Copie du thème dans ~/.themes..."
    cp -r "$TEMP_DIR" "$THEMES_DIR/$THEME_NAME"
    
    # Nettoyer le dossier temporaire
    rm -rf "$TEMP_DIR"
    
    echo "Thème installé avec succès dans $THEMES_DIR/$THEME_NAME"
else
    echo "Erreur lors du téléchargement du thème"
    exit 1
fi

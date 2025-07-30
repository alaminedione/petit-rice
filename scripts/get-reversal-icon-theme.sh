#!/bin/bash

set -e  # Arrête le script en cas d'erreur

REPO_URL="https://github.com/yeyushengfan258/Reversal-icon-theme"
REPO_NAME="Reversal-icon-theme"

# Créer un dossier temporaire pour le clonage
TMP_DIR=$(mktemp -d)

echo "Clonage du dépôt dans $TMP_DIR..."
git clone "$REPO_URL" "$TMP_DIR/$REPO_NAME" || { echo "Échec du clonage du dépôt."; exit 1; }

cd "$TMP_DIR/$REPO_NAME" || { echo "Impossible d'accéder au dossier du dépôt."; exit 1; }

echo "Lancement de l'installation..."
if [ -x ./install.sh ]; then
    ./install.sh
    echo "Installation terminée avec succès."
else
    echo "Le script install.sh n'est pas exécutable ou introuvable."
    exit 1
fi

# Nettoyage
cd ~
rm -rf "$TMP_DIR"

echo "Tout est terminé !"

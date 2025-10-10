#!/bin/bash

# Description: This script installs and configures SDDM with the "sugar-candy" theme.

# Exit immediately if a command exits with a non-zero status.
set -e

# 1. Install SDDM and its dependencies
echo "Installing SDDM and required dependencies..."
sudo pacman -S --needed --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg

# 2. Install the SDDM theme
THEME_NAME="sugar-candy"  # Nom du dossier du thème (sans le préfixe sddm-theme-)
THEME_SRC_DIR="../assets/sddm-theme-sugar-candy"
THEME_DEST_DIR="/usr/share/sddm/themes"

echo "Installing theme: $THEME_NAME..."

# Check if the source theme directory exists
if [ ! -d "$THEME_SRC_DIR" ]; then
    echo "Error: Theme source directory not found at '$THEME_SRC_DIR'."
    echo "Please ensure the script is run from the 'scripts' directory."
    exit 1
fi

# Create the destination directory and copy the theme
sudo mkdir -p "$THEME_DEST_DIR"
sudo cp -r "$THEME_SRC_DIR" "$THEME_DEST_DIR/$THEME_NAME"  # Copier avec le bon nom

# 3. Configure SDDM to use the new theme
echo "Configuring SDDM to use '$THEME_NAME'..."

# Créer ou mettre à jour le fichier de configuration
if [ -f /etc/sddm.conf ]; then
    # Sauvegarder l'ancienne configuration
    sudo cp /etc/sddm.conf /etc/sddm.conf.bak
    echo "Backup created at /etc/sddm.conf.bak"
fi

# Écrire la configuration
cat << EOF | sudo tee /etc/sddm.conf > /dev/null
[Theme]
Current=$THEME_NAME

[General]
# Optionnel : autres configurations
# Numlock=on
# InputMethod=
EOF

# 4. Vérifier l'installation
if [ -d "$THEME_DEST_DIR/$THEME_NAME" ]; then
    echo "✓ Theme installed successfully at $THEME_DEST_DIR/$THEME_NAME"
else
    echo "✗ Theme installation failed"
    exit 1
fi

echo ""
echo "SDDM has been configured successfully!"
echo "To enable SDDM:"
echo "  sudo systemctl enable sddm"
echo "To start SDDM now:"
echo "  sudo systemctl start sddm"

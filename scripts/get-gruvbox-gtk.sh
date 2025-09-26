#!/bin/bash
set -e

# Vérifier si le thème est déjà installé
if [ -d ~/.themes/Gruvbox-Dark/ ]; then
    echo "Gruvbox-GTK-Theme is already installed."
else
    # Cloner le dépôt
    git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme

    # Installer le thème
    cd Gruvbox-GTK-Theme
    ./themes/install.sh

    # Nettoyer le dossier cloné
    cd ..
    rm -rf Gruvbox-GTK-Theme

    echo "Installation terminée."
fi

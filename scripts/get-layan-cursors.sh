#!/bin/bash

# Créer un répertoire temporaire
tmp_dir=$(mktemp -d)

# Cloner le dépôt dans ce répertoire temporaire
git clone https://github.com/vinceliuice/Layan-cursors.git "$tmp_dir"

# Se déplacer dans le répertoire cloné
cd "$tmp_dir" || { echo "Erreur: impossible d'accéder au répertoire temporaire"; exit 1; }

# Rendre le script install.sh exécutable (au cas où)
chmod +x install.sh

# Exécuter le script d'installation
./install.sh

# Optionnel : supprimer le répertoire temporaire après installation
rm -rf "$tmp_dir"


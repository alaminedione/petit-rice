#!/bin/bash

# Script pour installer vim-plug et lancer PlugInstall automatiquement

set -e

# Vérifier que curl est installé
if ! command -v curl &> /dev/null; then
  echo "Erreur : curl n'est pas installé. Veuillez l'installer avant de continuer."
  exit 1
fi

# Vérifier que vim est installé
if ! command -v vim &> /dev/null; then
  echo "Erreur : vim n'est pas installé. Veuillez l'installer avant de continuer."
  exit 1
fi

echo "Installation de vim-plug..."

# Télécharger plug.vim dans le dossier autoload (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "vim-plug installé avec succès."

echo "Installation des plugins Vim via :PlugInstall..."

# Lancer vim en mode batch pour installer les plugins
vim +PlugInstall +qall

echo "Plugins installés avec succès."
echo "Vous pouvez maintenant utiliser Vim avec vos plugins gérés par vim-plug."


#!/bin/bash

set -e

# Vérifier si Zsh est installé, sinon l'installer (Arch Linux)
if ! command -v zsh &> /dev/null; then
  echo "Zsh non trouvé, installation en cours..."
  sudo pacman -Sy --noconfirm zsh
else
  echo "Zsh est déjà installé."
fi

# Installer Oh My Zsh si pas déjà présent
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installation d'Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh est déjà installé."
fi

# Définir Zsh comme shell par défaut pour l'utilisateur actuel
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Définition de Zsh comme shell par défaut..."
  chsh -s "$(which zsh)"
else
  echo "Zsh est déjà le shell par défaut."
fi

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# fzf (plugin Oh My Zsh + outil fzf)
sudo pacman -S --needed fzf  # installe l'outil fzf sur Arch Linux
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install  # installe fzf et ses bindings

# vi-mode est inclus dans Oh My Zsh, pas besoin d’installation

# gitignore
# Note : ce plugin est inclus dans Oh My Zsh, vous pouvez juste activer "gitignore" dans plugins

echo "Configuration terminée."

echo "Pour appliquer la configuration, ouvrez un nouveau terminal ou lancez :"
echo "source ~/.zshrc"

echo "Installation et configuration terminées avec succès."


#!/bin/bash

set -e

# Check if Zsh is installed, otherwise install it (Arch Linux)
if ! command -v zsh &> /dev/null; then
  echo "Zsh not found, installing..."
  sudo pacman -Sy --noconfirm zsh
else
  echo "Zsh is already installed."
fi

# Install Oh My Zsh if not already present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh is already installed."
fi

# Set Zsh as default shell for the current user
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
else
  echo "Zsh is already the default shell."
fi


# zsh-autosuggestions
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  echo "zsh-autosuggestions is already installed."
else
  echo "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  echo "zsh-syntax-highlighting is already installed."
else
  echo "Cloning zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# zsh-completions
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
  echo "zsh-completions is already installed."
else
  echo "Cloning zsh-completions..."
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

# fzf (Oh My Zsh plugin + fzf tool)
# Vérifie si fzf est déjà installé

if command -v fzf &> /dev/null; then
  echo "fzf is already installed."
else
  # Vérifie si le dépôt est déjà cloné
  REPO_PATH="$HOME/.fzf"
  SHOULD_CLEAN=false
  
  if [ -d "$REPO_PATH" ]; then
    echo "fzf repository is already cloned."
  else
    echo "Cloning fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$REPO_PATH"
    SHOULD_CLEAN=true
  fi
  
  # Exécute l'installation
  echo "Installing fzf..."
  yes | "$REPO_PATH/install" --all
  
  # Nettoie le dépôt seulement si nous l'avons cloné
  if [ "$SHOULD_CLEAN" = true ] && command -v fzf &> /dev/null; then
    echo "Cleaning up repository..."
    rm -rf "$REPO_PATH"
  fi
fi

echo "fzf installation completed."
# vi-mode is included in Oh My Zsh, no installation needed

# gitignore
# Note: this plugin is included in Oh My Zsh, you can just activate "gitignore" in plugins

echo "Configuration complete."

echo "To apply the configuration, open a new terminal or run:"
echo "source ~/.zshrc"

echo "Installation and configuration finished successfully."

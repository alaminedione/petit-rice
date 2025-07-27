# 🚀 Guide d'Installation Complet - Dotfiles Hotfiles

Ce guide vous accompagnera dans l'installation complète et la configuration de votre environnement de développement avec les dotfiles Hotfiles.

## 📋 Table des Matières

1. [Prérequis](#prérequis)
2. [Vue d'ensemble](#vue-densemble)
3. [Installation rapide](#installation-rapide)
4. [Installation détaillée](#installation-détaillée)
5. [Configuration des applications](#configuration-des-applications)
6. [Thèmes disponibles](#thèmes-disponibles)
7. [Scripts utilitaires](#scripts-utilitaires)
8. [Dépannage](#dépannage)
9. [Sauvegarde et restauration](#sauvegarde-et-restauration)
10. [Personnalisation](#personnalisation)

---

## 🔧 Prérequis

### Système d'exploitation
- **Arch Linux** (recommandé) ou distributions basées sur Arch
- **Wayland** (Sway ou Hyprland)

### Outils requis
```bash
# Installation des outils de base
sudo pacman -S --needed base-devel git
```

### AUR Helper (yay)
Si vous n'avez pas encore `yay` installé :
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

---

## 🌟 Vue d'ensemble

Les dotfiles Hotfiles incluent des configurations pour :

### 🖥️ Environnements de bureau
- **Sway** - Gestionnaire de fenêtres Wayland minimaliste
- **Hyprland** - Compositeur Wayland moderne avec animations

### 🖥️ Applications configurées
- **Terminaux** : Kitty, Foot, Ghostty
- **Éditeurs** : Neovim (NvChad), Vim, Zed, VS Code
- **Barres de statut** : Waybar
- **Lanceurs** : Wofi
- **Notifications** : Mako
- **Verrouillage d'écran** : Swaylock, Hyprlock
- **Informations système** : Fastfetch

### 🎨 Thèmes supportés

courant: 
   - **Catppuccin macchiato**
   - **Rose Pine Dawn**

à venir:
- **Catppuccin** (Mocha,  Latte, Frappe)
- **Rose Pine** ( Moon)
- **Gruvbox** (Dark, Light)
- **GitHub** (Light)
- **Flexoki** (Light)
- **Nordic** (Dark, Light)
- **Gruvbox** (Dark, Light)

---

## ⚡ Installation 


```bash
# Cloner le repository
git clone https://github.com/alaminedione/hotfiles.git ~/hotfiles
cd ~/hotfiles

# Rendre le script exécutable
chmod +x install.sh

# Lancer l'installation complète
./install.sh
```

Le script d'installation crée automatiquement une sauvegarde de vos configurations existantes dans :
```
~/.config-backups/backup-YYYYMMDD-HHMMSS/
```


## Catégories d'applications disponibles :

lors de l'installation le script va vous permettre de choisir les applications que vous souhaitez installer:

1. **Base système** : debugedit, freetype2-ubuntu, fontconfig-ubuntu, cairo-ubuntu
2. **Éditeurs** : code, neovim, zed, nano, vim
3. **Terminaux** : ghostty, kitty, foot
4. **Outils développement CLI** : github-cli, glab, lazygit, cargo-tauri, composer, pnpm, uv, ts-node, sccache, bc, lazydocker-bin
5. **Outils système** : htop, fastfetch, bat, eza, tree, hyperfine, onefetch, cloc, yazi, rsync, wget, croc, tgpt, gpu-screen-recorder-gtk, pipes.sh
6. **Containerisation** : docker, docker-compose, podman, qemu
7. **Apps développement graphiques** : zeal
8. **Environnement Sway** : sway, wofi, slurp, wlsunset
9. **Hyprland** : hyprland, hyprlock, hyprpaper, hyprsunset
10. **Serveur X** : xorg-server, xorg-xinit, xf86-video-amdgpu, xf86-video-ati
11. **Thèmes et apparence** : adapta-gtk-theme, orchis-theme, kvantum, lxappearance
12. **Polices** : adobe-source-code-pro-fonts, ttf-fira-code, ttf-fira-sans, ttf-hack, ttf-jetbrains-mono-nerd, ttf-ubuntu-font-family
13. **Multimédia** : vlc, clapper, cheese, viewnior, pavucontrol
14. **Applications utilisateur** : firefox, telegram-desktop, galculator, atril, yt-dlp, onlyoffice-bin
15. **Réseau et sécurité** : macchanger, wireless_tools, wpa_supplicant, iwgtk
16. **Utilitaires divers** : yq, freedownloadmanager



### Étape 5 : Scripts de configuration supplémentaires

Le script d'installation propose plusieurs scripts optionnels :

```bash
# amelioration des polices 
./scripts/fix_fonts.sh

# Configuration des paramètres GNOME
./scripts/gsettings.sh

# Installation des curseurs Layan
./scripts/get-layan-cursors.sh

# Configuration de Zsh
./scripts/config-zsh.sh

# Configuration de Vim
./scripts/config-vim.sh

# Configuration du swapinness
./scripts/set-swapinness.sh

# Création du service macspoof
./scripts/create_macspoof_service.sh
```

---

## 🔧 Configuration des applications

### Neovim (NvChad)
Configuration complète avec 
- **LSP** : Support pour de nombreux langages: C, C++, Java, JavaScript, Lua, Python, Rust, TypeScript, YAML, JSON, Go, React, HTML, Css, VueJs, Php
- **Treesitter** : Coloration syntaxique avancée
- **Lazy.nvim** : Gestionnaire de plugins moderne
- **Supermaven** : Assistant IA pour le code
- **Conform** : Formatage automatique
- **Noice** : Interface utilisateur améliorée

#### Première utilisation :
```bash
# Lancer Neovim
nvim

# Les plugins se téléchargent automatiquement

# Redémarrer Neovim après l'installation des plugins

# executer mason install all pour installer les servers lsp
`:MasonInstallAll`

```

### Kitty Terminal
Configuration avec :
- **Polices** : JetBrains Mono Nerd Font
- **Raccourcis clavier** personnalisés 
- **Support des thèmes** multiples
- **Configuration des couleurs** adaptative

### Foot Terminal
Terminal léger pour Wayland avec :
- **Performance optimisée**
- **Support des thèmes** Catppuccin et Rose Pine
- **Configuration minimaliste**

### Sway
Gestionnaire de fenêtres avec :
- **Raccourcis clavier** intuitifs
- **Espaces de travail** configurés
- **Intégration Waybar**
- **Support multi-écrans**

#### Raccourcis principaux :
- `Super + Return` : Ouvrir un terminal
- `Super + a` : Ouvrir le lanceur d'applications
- `Super  q` : Fermer une fenêtre
- `Super + 1-9` : Changer d'espace de travail

### Hyprland
Compositeur moderne avec :
- **Animations fluides**
- **Effets visuels**
- **Configuration avancée**
- **Support des plugins**

### Waybar
Barre de statut avec :
- **Modules système** (CPU, RAM, réseau)
- **Lecteur multimédia**

---

## 🎨 Thèmes disponibles

### Changer de thème
```bash
# Aller dans le dossier des scripts de thème
cd ~/.config/hotfiles-scripts/change-theme

# Thèmes disponibles :
./set-mocha.sh           # Catppuccin Mocha (sombre)
./set-rose-pine-dawn.sh  # Rose Pine Dawn (clair)

# Ou depuis n'importe où :
~/.config/hotfiles-scripts/change-theme/set-mocha.sh
```


### Thèmes supportés par application

#### Catppuccin
- **Macchiato** (sombre) - Thème par défaut
- **rose-pine-dawn** (clair)

---

## 🛠️ Scripts utilitaires

Tous les scripts sont installés dans `~/.config/hotfiles-scripts/` :

### Scripts de thème
```bash
# Changer vers Catppuccin Mocha
~/.config/hotfiles-scripts/change-theme/set-mocha.sh

# Changer vers Rose Pine Dawn
~/.config/hotfiles-scripts/change-theme/set-rose-pine-dawn.sh
```

### Scripts système
```bash
# Correction des polices
~/.config/hotfiles-scripts/fix_fonts.sh

# Configuration Zsh
~/.config/hotfiles-scripts/config-zsh.sh

# Configuration Vim
~/.config/hotfiles-scripts/config-vim.sh

# Réglage du swapinness
~/.config/hotfiles-scripts/set-swapinness.sh
```

### Scripts réseau
```bash
# Service macspoof
~/.config/hotfiles-scripts/create_macspoof_service.sh

# Restriction temporelle
~/.config/hotfiles-scripts/time-restrict.sh
```

---

## 🔍 Dépannage

### Problèmes courants

#### 1. Polices manquantes
```bash
# Installer les polices Nerd
yay -S ttf-jetbrains-mono-nerd

# Reconstruire le cache des polices
fc-cache -fv

# Exécuter le script de correction
~/.config/hotfiles-scripts/fix_fonts.sh
```

---

## 💾 Sauvegarde et restauration

### Système de sauvegarde automatique

Le script d'installation crée automatiquement des sauvegardes dans :
```
~/.config-backups/backup-YYYYMMDD-HHMMSS/
```

### Restaurer une sauvegarde
```bash
# Lister les sauvegardes disponibles
ls ~/.config-backups/

# Restaurer une sauvegarde spécifique
./restore.sh 20240127-143022

# Ou restaurer la plus récente
./restore.sh latest
```

### Sauvegarde manuelle
```bash
# Créer une sauvegarde manuelle
mkdir -p ~/.config-backups/manual-$(date +%Y%m%d-%H%M%S)
cp -r ~/.config/sway ~/.config-backups/manual-$(date +%Y%m%d-%H%M%S)/
cp -r ~/.config/kitty ~/.config-backups/manual-$(date +%Y%m%d-%H%M%S)/
# ... autres configurations
```

### Script de restauration
Le script `restore.sh` permet de :
- Lister toutes les sauvegardes disponibles
- Restaurer sélectivement des configurations
- Créer une sauvegarde avant restauration
- Valider l'intégrité des sauvegardes

---

## 🎯 Personnalisation

## 🆘 Support et contribution

### Signaler un problème
1. Vérifiez les [problèmes connus](#dépannage)
2. Consultez les logs système
3. Créez une issue avec :
   - Description du problème
   - Étapes pour reproduire
   - Logs pertinents
   - Configuration système

### Contribuer
1. Fork le repository
2. Créez une branche pour votre fonctionnalité
3. Testez vos modifications
4. Soumettez une pull request





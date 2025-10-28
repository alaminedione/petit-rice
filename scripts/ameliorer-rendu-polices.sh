#!/bin/bash

# Script d'amélioration du rendu des polices sur Arch Linux
# Compatible X11 et Wayland

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Vérifier si on est sur Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "Ce script est conçu pour Arch Linux"
    exit 1
fi

# Vérifier si yay est installé
if ! command -v yay &> /dev/null; then
    print_warning "yay n'est pas installé. Installation..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    print_success "yay installé"
fi

echo ""
print_info "=== Script d'amélioration des polices pour Arch Linux ==="
echo ""

# 1. Installer les paquets de base
print_info "Installation des paquets de base..."
sudo pacman -S --needed --noconfirm freetype2 fontconfig cairo
print_success "Paquets de base installés"

# 2. Installer les polices essentielles
print_info "Installation des polices essentielles..."
sudo pacman -S --needed --noconfirm ttf-dejavu ttf-liberation noto-fonts ttf-roboto ttf-roboto-mono ttf-font-awesome
print_success "Polices essentielles installées"

# 3. Demander si l'utilisateur veut installer les polices propriétaires
echo ""
print_info "Installation des polices propriétaires (Microsoft, macOS, Google)"
read -p "Voulez-vous installer les polices Microsoft ? (o/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    print_info "Installation des polices Microsoft..."
    yay -S --needed --noconfirm ttf-ms-fonts
    print_success "Polices Microsoft installées"
fi

read -p "Voulez-vous installer les polices macOS ? (o/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    print_info "Installation des polices macOS..."
    yay -S --needed --noconfirm ttf-mac-fonts
    print_success "Polices macOS installées"
fi

read -p "Voulez-vous installer Google Fonts (complet) ? (o/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    print_info "Installation de Google Fonts (cela peut prendre du temps)..."
    yay -S --needed --noconfirm ttf-google-fonts-git
    print_success "Google Fonts installées"
else
    print_info "Installation des polices Google populaires uniquement..."
    yay -S --needed --noconfirm ttf-opensans ttf-montserrat ttf-lato 2>/dev/null || print_warning "Certaines polices Google n'ont pas pu être installées"
fi

# 4. Créer le répertoire de configuration fontconfig
print_info "Configuration de fontconfig..."
mkdir -p ~/.config/fontconfig

# 5. Créer le fichier de configuration fonts.conf
cat > ~/.config/fontconfig/fonts.conf << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  
  <!-- Paramètres de rendu des polices -->
  <match target="font">
    <edit name="antialias" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hinting" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
      <const>hintslight</const>
    </edit>
    <edit name="rgba" mode="assign">
      <const>rgb</const>
    </edit>
    <edit name="lcdfilter" mode="assign">
      <const>lcddefault</const>
    </edit>
    <edit name="autohint" mode="assign">
      <bool>false</bool>
    </edit>
  </match>

  <!-- Désactiver les polices bitmap -->
  <selectfont>
    <rejectfont>
      <pattern>
        <patelt name="scalable">
          <bool>false</bool>
        </patelt>
      </pattern>
    </rejectfont>
  </selectfont>

  <!-- Polices par défaut -->
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Serif</family>
      <family>Liberation Serif</family>
      <family>DejaVu Serif</family>
    </prefer>
  </alias>
  
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Sans</family>
      <family>Liberation Sans</family>
      <family>DejaVu Sans</family>
    </prefer>
  </alias>
  
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Sans Mono</family>
      <family>Liberation Mono</family>
      <family>DejaVu Sans Mono</family>
    </prefer>
  </alias>

  <!-- Substitution des polices Microsoft -->
  <alias binding="same">
    <family>Arial</family>
    <accept>
      <family>Liberation Sans</family>
    </accept>
  </alias>
  
  <alias binding="same">
    <family>Times New Roman</family>
    <accept>
      <family>Liberation Serif</family>
    </accept>
  </alias>
  
  <alias binding="same">
    <family>Courier New</family>
    <accept>
      <family>Liberation Mono</family>
    </accept>
  </alias>

  <!-- Substitution Helvetica vers Liberation Sans ou Arial -->
  <alias binding="same">
    <family>Helvetica</family>
    <accept>
      <family>Liberation Sans</family>
    </accept>
  </alias>

</fontconfig>
EOF

print_success "Fichier fonts.conf créé"

# 6. Activer le rendu subpixel dans freetype2
if [ -f /etc/profile.d/freetype2.sh ]; then
    print_info "Activation du rendu subpixel dans freetype2..."
    sudo sed -i 's/#export FREETYPE_PROPERTIES/export FREETYPE_PROPERTIES/' /etc/profile.d/freetype2.sh 2>/dev/null || print_warning "Impossible de modifier freetype2.sh"
    print_success "Rendu subpixel activé"
fi

# 7. Lier la configuration pour désactiver les bitmaps (système)
if [ -f /etc/fonts/conf.avail/70-no-bitmaps.conf ]; then
    print_info "Désactivation des polices bitmap (système)..."
    sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/ 2>/dev/null || print_warning "Lien symbolique déjà existant"
    print_success "Polices bitmap désactivées"
fi

# 8. Recharger le cache des polices
print_info "Rechargement du cache des polices..."
fc-cache -fv > /dev/null 2>&1
print_success "Cache des polices rechargé"

# 9. Afficher les informations finales
echo ""
print_success "=== Configuration terminée avec succès ! ==="
echo ""
print_info "Prochaines étapes :"
echo "  1. Déconnectez-vous et reconnectez-vous pour appliquer tous les changements"
echo "  2. Redémarrez vos applications pour voir les améliorations"
echo ""
print_info "Configuration créée dans : ~/.config/fontconfig/fonts.conf"
print_info "Vous pouvez modifier ce fichier pour ajuster les paramètres"
echo ""
print_info "Pour vérifier les polices installées :"
echo "  fc-list : family | sort | uniq"
echo ""
print_success "Profitez de vos belles polices !"

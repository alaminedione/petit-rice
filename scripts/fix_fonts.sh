#!/bin/bash

set -e

echo "=== Optimisation du rendu des polices pour Wayland sur Arch Linux ==="

# 1. Supprimer les polices bitmap obsolètes
echo "[1/6] Suppression des anciennes polices..."
sudo pacman -Rns --noconfirm xorg-fonts-75dpi xorg-fonts-100dpi ttf-dejavu || true

# 2. Installer de bonnes polices modernes
echo "[2/6] Installation de polices modernes..."
sudo pacman -S --needed --noconfirm ttf-liberation ttf-ubuntu-font-family ttf-fira-sans ttf-fira-code noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd adobe-source-code-pro-fonts ttf-hack ttf-cascadia-code ttf-iosevka ttf-iosevka-nerd ttf-iosevka-term nerd-fonts-complete ttf-ubuntu-mono-nerd ttf-roboto ttf-libertinus-sans ttf-libertinus-serif ttf-dejavu

# 3. Installer les bibliothèques de rendu améliorées via yay
echo "[3/6] Installation de freetype2-ubuntu, fontconfig-ubuntu, cairo-ubuntu..."
if ! command -v yay &> /dev/null; then
  echo "yay non détecté. Installation..."
  sudo pacman -S --noconfirm yay
fi
yay -S --noconfirm freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu

# 4. Configuration fontconfig
echo "[4/6] Configuration du rendu via fontconfig..."
mkdir -p ~/.config/fontconfig

cat > ~/.config/fontconfig/fonts.conf <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
    <edit name="hinting" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
    <edit name="lcdfilter" mode="assign"><const>lcdlight</const></edit>
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
  </match>
</fontconfig>
EOF

# 5. Rafraîchissement du cache de polices
echo "[5/6] Rafraîchissement du cache de polices..."
fc-cache -f -v

# 6. (Optionnel) Installer les polices Microsoft
read -p "Souhaitez-vous installer les polices Microsoft (Arial, Calibri, etc.) ? [y/N]: " install_ms
if [[ "$install_ms" =~ ^[Yy]$ ]]; then
  yay -S --noconfirm ttf-ms-fonts
fi

echo "✅ Terminé ! Déconnectez-vous ou redémarrez pour appliquer les changements."


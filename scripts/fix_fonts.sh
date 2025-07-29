#!/bin/bash

set -e

echo "=== Font rendering optimization for Wayland on Arch Linux ==="

# 1. Remove obsolete bitmap fonts
echo "[1/6] Removing old fonts..."
sudo pacman -Rns --noconfirm xorg-fonts-75dpi xorg-fonts-100dpi ttf-dejavu || true

# 2. Install modern fonts
echo "[2/6] Installing modern fonts..."
sudo yay -S --needed --noconfirm ttf-liberation ttf-ubuntu-font-family ttf-fira-sans ttf-fira-code noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd adobe-source-code-pro-fonts ttf-hack ttf-cascadia-code ttf-iosevka ttf-iosevka-nerd ttf-iosevka-term nerd-fonts-complete ttf-ubuntu-mono-nerd ttf-roboto ttf-libertinus-sans ttf-libertinus-serif ttf-dejavu

# 3. Install improved rendering libraries via yay
echo "[3/6] Installing freetype2-ubuntu, fontconfig-ubuntu, cairo-ubuntu..."
if ! command -v yay &> /dev/null; then
  echo "yay not detected. Installing..."
  sudo pacman -S --noconfirm yay
fi
yay -S --noconfirm freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu

# 4. Fontconfig configuration
echo "[4/6] Configuring rendering via fontconfig..."
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

# 5. Refresh font cache
echo "[5/6] Refreshing font cache..."
fc-cache -f -v

# 6. (Optional) Install Microsoft fonts
read -p "Do you want to install Microsoft fonts (Arial, Calibri, etc.)? [y/N]: " install_ms
if [[ "$install_ms" =~ ^[Yy]$ ]]; then
  yay -S --noconfirm ttf-ms-fonts
fi

echo "✅ Done! Log out or restart to apply changes."

#!/bin/bash

set -e  # Arrêter le script en cas d'erreur

echo "=== Installation de greetd + tuigreet sur Arch Linux ==="


sudo pacman -S --needed --noconfirm greetd greetd-tuigreet

sudo mkdir -p /etc/greetd

sudo tee /etc/greetd/config.toml > /dev/null << 'EOF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --remember-user-session --asterisks"
user = "greeter"
EOF

# Detecting and disabling other display managers..."
DM_SERVICES=("gdm" "sddm" "lightdm" "xdm" "lxdm")

for dm in "${DM_SERVICES[@]}"; do
    if systemctl is-enabled "$dm.service" &>/dev/null; then
        echo "   Detected $dm.service, disabling..."
        sudo systemctl disable "$dm.service"
    fi
done

sudo systemctl enable greetd.service

echo "=== Installation completed successfully! ==="
echo ""
echo "Configuration created in /etc/greetd/config.toml"
echo "greetd.service is now enabled"
echo ""

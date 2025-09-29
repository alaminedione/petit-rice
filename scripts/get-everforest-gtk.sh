
#!/bin/bash

set -e

# Installer la dépendance nécessaire
sudo pacman -S --needed --noconfirm gtk-engine-murrine

# Cloner le dépôt du thème Everforest (profondeur 1 pour rapidité)
git clone --depth 1 https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme /tmp/Everforest-GTK-Theme

# Exécuter le script d'installation fourni
bash /tmp/Everforest-GTK-Theme/themes/install.sh




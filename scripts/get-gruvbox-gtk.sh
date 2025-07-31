
#!/usr/bin/env bash
# Script pour cloner et installer le thème Gruvbox GTK

set -euo pipefail
IFS=$'\n\t'

# Vérifie que le thème n'est pas déjà installé
THEME_NAME="Gruvbox-Dark"
INSTALL_PATHS=( "$HOME/.themes" "/usr/share/themes" )

for path in "${INSTALL_PATHS[@]}"; do
    if [ -d "$path/$THEME_NAME" ]; then
        echo "Le thème $THEME_NAME est déjà installé dans $path. Abandon."
        exit 0
    fi
done


echo "Clonage et installation du thème Gruvbox GTK..."

# Crée un répertoire temporaire, assure sa suppression même si le script plante
TMP_DIR=$(mktemp -d)
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Clone le dépôt dans TMP_DIR
if ! git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme "$TMP_DIR"; then
    echo "Erreur : Échec du clonage du dépôt. Abandon."
    exit 1
fi

# Lance le script d'installation
cd "$TMP_DIR/themes"
if ! ./install.sh; then
    echo "Erreur : L'installation du thème GTK a échoué. Veuillez vérifier les logs."
    exit 1
fi

echo "Installation du thème Gruvbox GTK terminée avec succès."


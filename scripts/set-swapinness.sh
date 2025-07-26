#!/bin/bash

# Script pour configurer swappiness à 10 sur Arch Linux

# Vérifie si le script est lancé en root
if [ "$EUID" -ne 0 ]; then
  echo "Merci de lancer ce script en tant que root ou avec sudo."
  exit 1
fi

# Valeur souhaitée
SWAPPINESS_VALUE=10

# Appliquer la valeur immédiatement
sysctl -w vm.swappiness=$SWAPPINESS_VALUE

# Créer ou modifier le fichier de configuration pour rendre la modification persistante
CONF_FILE="/etc/sysctl.d/99-swappiness.conf"
echo "vm.swappiness=$SWAPPINESS_VALUE" > "$CONF_FILE"

# Appliquer toutes les configurations sysctl
sysctl --system

echo "Swappiness réglé à $SWAPPINESS_VALUE et rendu permanent via $CONF_FILE"


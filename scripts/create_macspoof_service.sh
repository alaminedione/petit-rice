#!/bin/bash

# Script pour créer et activer un service systemd template macspoof@.service pour wlan0
# Usage : sudo ./create_macspoof_service.sh

SERVICE_PATH="/etc/systemd/system/macspoof@.service"
INTERFACE="wlan0"

# Vérification des permissions root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Ce script doit être exécuté en tant que root (sudo)." >&2
  exit 1
fi

# Vérification que macchanger est installé
if ! command -v macchanger >/dev/null 2>&1; then
  echo "❌ Erreur : macchanger n'est pas installé. Installez-le avec : apt install macchanger" >&2
  exit 1
fi

# Contenu du fichier service
read -r -d '' SERVICE_CONTENT <<'EOF'
[Unit]
Description=Change MAC address on %I
Wants=network-pre.target
Before=network-pre.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
ExecStart=/usr/bin/macchanger -r %I

[Install]
WantedBy=multi-user.target
EOF

echo "🛠️ Création du fichier de service systemd : $SERVICE_PATH"

# Écrire le fichier service
echo "$SERVICE_CONTENT" > "$SERVICE_PATH"

# Recharger systemd
echo "🔄 Rechargement du démon systemd..."
systemctl daemon-reload

# Activer le service pour wlan0
echo "📡 Activation du service macspoof@wlan0.service"
systemctl enable macspoof@wlan0.service

echo "✅ Service macspoof@wlan0.service créé et activé avec succès."
echo "🔁 Redémarrez votre système pour appliquer automatiquement le changement d'adresse MAC au démarrage."


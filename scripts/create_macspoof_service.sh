#!/bin/bash

# Script to create and enable a systemd template service macspoof@.service for wlan0
# Usage: ./create_macspoof_service.sh

SERVICE_PATH="/etc/systemd/system/macspoof@.service"
INTERFACE="wlan0"

# Check if macchanger is installed
if ! command -v macchanger >/dev/null 2>&1; then
  echo "❌ Error: macchanger is not installed. Install it with: apt install macchanger" >&2
  exit 1
fi

# Service file content
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

echo "🛠️ Creating systemd service file: $SERVICE_PATH"

# Write the service file
echo "$SERVICE_CONTENT" | sudo tee "$SERVICE_PATH" > /dev/null

# Reload systemd
echo "🔄 Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the service for wlan0
echo "📡 Enabling macspoof@wlan0.service"
sudo systemctl enable macspoof@wlan0.service

echo "✅ macspoof@wlan0.service created and enabled successfully."
echo "🔁 Restart your system to automatically apply the MAC address change on boot."

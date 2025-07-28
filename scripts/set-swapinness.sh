#!/bin/bash

# Script to configure swappiness to 10 on Arch Linux

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Desired value
SWAPPINESS_VALUE=10

# Apply the value immediately
sysctl -w vm.swappiness=$SWAPPINESS_VALUE

# Create or modify the configuration file to make the change persistent
CONF_FILE="/etc/sysctl.d/99-swappiness.conf"
echo "vm.swappiness=$SWAPPINESS_VALUE" > "$CONF_FILE"

# Apply all sysctl configurations
sysctl --system

echo "Swappiness set to $SWAPPINESS_VALUE and made permanent via $CONF_FILE"

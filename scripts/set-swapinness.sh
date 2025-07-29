#!/bin/bash

# Script to configure swappiness to 10 on Arch Linux

# Desired value
SWAPPINESS_VALUE=10

# Apply the value immediately
sysctl -w vm.swappiness=$SWAPPINESS_VALUE

# Create or modify the configuration file to make the change persistent
CONF_FILE="/etc/sysctl.d/99-swappiness.conf"
echo "vm.swappiness=$SWAPPINESS_VALUE" | sudo tee "$CONF_FILE" > /dev/null

# Apply all sysctl configurations
sudo sysctl --system

echo "Swappiness set to $SWAPPINESS_VALUE and made permanent via $CONF_FILE"

#!/bin/bash

# Detect the current window manager and reload its configuration

if pgrep -x "sway" > /dev/null; then
    echo "Sway detected. Reloading configuration..."
    pkill mako
    pkill waybar
    pkill swaybg
    pkill wlsunset

    sleep 1
    swaymsg reload

    echo "Sway configuration reloaded."
    notify-send "Sway configuration reloaded."
elif pgrep -x "Hyprland" > /dev/null; then
    echo "Hyprland detected. Reloading configuration..."
    pkill waybar
    pkill mako
    pkill hyprpaper 
    pkill hyprsunset
    sleep 1
    hyprctl reload
    echo "Hyprland configuration reloaded."
    notify-send "Hyprland configuration reloaded."
else
    echo "No supported window manager (sway or Hyprland) detected."
fi

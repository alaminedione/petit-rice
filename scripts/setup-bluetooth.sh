#!/bin/bash

sudo pacman -S --needed bluez bluez-utils

sudo systemctl enable bluetooth.service

#frontend to manage bluetooth

sudo pacman -S --needed bluetui



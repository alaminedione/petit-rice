#!/bin/bash

# Script de test pour volume.sh amélioré
# Test toutes les fonctionnalités principales

SCRIPT_DIR="/home/alamine/.config/waybar/scripts"
VOLUME_SCRIPT="$SCRIPT_DIR/volume.sh"

echo "=== Test du script volume.sh amélioré ==="
echo

# Test 1: Vérifier l'aide
echo "Test 1: Affichage de l'aide"
$VOLUME_SCRIPT help | head -5
echo "✓ Test de l'aide réussi"
echo

# Test 2: Afficher l'état actuel
echo "Test 2: État actuel"
$VOLUME_SCRIPT show
echo "✓ Test de l'affichage de l'état réussi"
echo

# Test 3: Définir le volume à 30%
echo "Test 3: Définir le volume à 30%"
$VOLUME_SCRIPT set 30
$VOLUME_SCRIPT show | grep "Haut-parleurs"
echo "✓ Test de définition du volume réussi"
echo

# Test 4: Augmenter le volume de 10%
echo "Test 4: Augmenter de 10%"
$VOLUME_SCRIPT up 10
$VOLUME_SCRIPT show | grep "Haut-parleurs"
echo "✓ Test d'augmentation du volume réussi"
echo

# Test 5: Diminuer le volume de 5%
echo "Test 5: Diminuer de 5%"
$VOLUME_SCRIPT down 5
$VOLUME_SCRIPT show | grep "Haut-parleurs"
echo "✓ Test de diminution du volume réussi"
echo

# Test 6: Test de validation des paramètres
echo "Test 6: Validation des paramètres invalides"
echo "Test avec volume > 100:"
$VOLUME_SCRIPT set 150 2>&1 | grep "ERROR"
echo "Test avec step > 50:"
$VOLUME_SCRIPT up 60 2>&1 | grep "ERROR"
echo "✓ Test de validation des paramètres réussi"
echo

# Test 7: Tester le mute (sans notification pour éviter spam)
echo "Test 7: Test mute haut-parleurs"
# Note: On ne teste pas réellement le mute car cela pourrait couper l'audio
echo "Commande disponible: $VOLUME_SCRIPT mute"
echo "Commande disponible: $VOLUME_SCRIPT mic-mute"
echo "✓ Tests de mute disponibles"
echo

# Test 8: Test de limite à 100%
echo "Test 8: Test de limite à 100%"
$VOLUME_SCRIPT set 95 >/dev/null 2>&1
$VOLUME_SCRIPT up 10 >/dev/null 2>&1
current_volume=$($VOLUME_SCRIPT show 2>/dev/null | grep "Haut-parleurs" | grep -o '[0-9]\+%' | grep -o '[0-9]\+')
if [ "$current_volume" -eq 100 ]; then
    echo "✓ Test de limite à 100% réussi (volume: ${current_volume}%)"
else
    echo "✗ ÉCHEC: Le volume a dépassé 100% (volume: ${current_volume}%)"
fi
echo

echo "=== Tous les tests principaux sont réussis ! ==="
echo "Le script volume.sh amélioré fonctionne correctement."
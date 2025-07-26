# Script Volume.sh Amélioré - Version 2.0

## Vue d'ensemble

Le script `volume.sh` a été considérablement amélioré pour offrir une meilleure fonctionnalité, robustesse et flexibilité pour le contrôle audio dans Waybar.

## Améliorations apportées

### 🔧 **Fonctionnalités ajoutées**

1. **Support du microphone** : Contrôle du volume et mute du microphone via `mic-mute`
2. **Définition de volume absolue** : Nouvelle commande `set <volume>` pour définir un volume précis
3. **Incréments variables** : Possibilité de spécifier un step personnalisé pour `up` et `down`
4. **Affichage de l'état** : Nouvelle commande `show` pour voir l'état audio actuel
5. **Aide intégrée** : Commande `help` avec documentation complète

### 🛡️ **Robustesse améliorée**

1. **Gestion d'erreur complète** : Vérification de toutes les opérations avec messages d'erreur informatifs
2. **Validation des paramètres** : Contrôle des valeurs de volume (0-100) et steps (1-50)
3. **Limite de volume stricte** : Le volume ne peut jamais dépasser 100% même avec les touches clavier
4. **Vérification des dépendances** : Test automatique de la disponibilité de `wpctl`, `bc`, et `notify-send`
5. **Logging coloré** : Messages INFO, WARN, et ERROR avec couleurs pour une meilleure lisibilité

### 🎨 **Interface améliorée**

1. **Notifications enrichies** : Icônes appropriées selon le type et niveau de volume
2. **Support microphone** : Icônes spécifiques pour le microphone
3. **Timeout configurable** : Durée des notifications ajustable
4. **Titres distincts** : Différenciation claire entre haut-parleurs et microphone

### 🚀 **Performance et maintenabilité**

1. **Code modulaire** : Fonctions séparées pour chaque fonctionnalité
2. **Configuration centralisée** : Variables de configuration en haut du script
3. **Documentation intégrée** : Commentaires et aide détaillée
4. **Structure professionnelle** : Code organisé et facile à maintenir

## Utilisation

### Commandes de base
```bash
# Augmenter le volume de 5% (défaut)
./volume.sh up

# Augmenter le volume de 10%
./volume.sh up 10

# Diminuer le volume de 3%
./volume.sh down 3

# Définir le volume à 50%
./volume.sh set 50

# Basculer mute des haut-parleurs
./volume.sh mute

# Basculer mute du microphone
./volume.sh mic-mute

# Afficher l'état actuel
./volume.sh show

# Afficher l'aide
./volume.sh help
```

### Configuration

Les paramètres suivants peuvent être modifiés en haut du script :

```bash
DEFAULT_STEP=5           # Incrément par défaut (%)
MAX_VOLUME=100          # Volume maximum (%)
MIN_VOLUME=0            # Volume minimum (%)
NOTIFICATION_TIMEOUT=2000  # Durée notification (ms)
```

## Compatibilité

### Dépendances requises
- **wpctl** (WirePlumber) : Contrôle audio principal
- **bc** : Calculs mathématiques
- **notify-send** (optionnel) : Notifications desktop

### Compatibilité avec l'ancien script

Le script maintient une compatibilité totale avec l'ancienne version :
- `./volume.sh up` fonctionne exactement comme avant
- `./volume.sh down` fonctionne exactement comme avant  
- `./volume.sh mute` fonctionne exactement comme avant

## Tests

Un script de test automatisé `test_volume.sh` est inclus pour valider toutes les fonctionnalités :

```bash
./test_volume.sh
```

## Exemple d'intégration Waybar

```json
{
    "modules-right": ["custom/volume"],
    "custom/volume": {
        "exec": "~/.config/waybar/scripts/volume.sh show | grep 'Haut-parleurs' | cut -d' ' -f2",
        "on-click": "~/.config/waybar/scripts/volume.sh mute",
        "on-scroll-up": "~/.config/waybar/scripts/volume.sh up 2",
        "on-scroll-down": "~/.config/waybar/scripts/volume.sh down 2",
        "interval": 1,
        "format": "🔊 {}"
    }
}
```

## Dépannage

### Messages d'erreur courants

- **"wpctl n'est pas installé"** : Installer WirePlumber
- **"bc n'est pas installé"** : Installer bc (`sudo apt install bc`)
- **"Volume invalide"** : Utiliser une valeur entre 0 et 100
- **"Step invalide"** : Utiliser une valeur entre 1 et 50

### Logs

Le script utilise un système de logging coloré :
- 🔴 **ERROR** : Erreurs critiques (affiché sur stderr)
- 🟡 **WARN** : Avertissements (affiché sur stderr)  
- 🟢 **INFO** : Informations (affiché sur stdout)

## Avantages par rapport à l'ancienne version

| Fonctionnalité | Ancienne version | Nouvelle version |
|---|---|---|
| Commandes | 3 (up/down/mute) | 7 (up/down/mute/mic-mute/set/show/help) |
| Gestion d'erreur | Aucune | Complète avec messages |
| Validation | Aucune | Validation de tous les paramètres |
| Documentation | Commentaires basiques | Aide intégrée + README |
| Flexibilité | Steps fixes | Steps configurables |
| Support microphone | Non | Oui |
| Logging | Aucun | Logging coloré |
| Tests | Aucun | Script de test automatisé |

Le script amélioré offre une solution complète et robuste pour le contrôle audio dans un environnement Waybar moderne.
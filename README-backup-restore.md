# Système de Sauvegarde et Restauration des Dotfiles

Ce système offre une solution complète pour sauvegarder et restaurer vos configurations de dotfiles avec un dossier de sauvegarde unique et un système de restauration flexible.

## 🚀 Fonctionnalités

### Sauvegarde Globale
- **Un seul dossier de sauvegarde** avec timestamp pour toutes les configurations
- **Sauvegarde automatique** avant chaque installation
- **Fichier d'information** détaillant le contenu de chaque sauvegarde
- **Préservation de la structure** des fichiers et dossiers

### Restauration Flexible
- **Menu interactif** pour sélectionner une sauvegarde
- **Restauration par timestamp** spécifique
- **Sauvegarde de sécurité** automatique avant restauration
- **Gestion des sauvegardes** (liste, détails, suppression, nettoyage)

## 📁 Structure des Sauvegardes

```
~/.config-backups/
├── backup-20240127-143052/
│   ├── backup-info.txt
│   ├── foot/
│   ├── kitty/
│   ├── nvim/
│   ├── sway/
│   ├── waybar/
│   └── hotfiles-scripts/
├── backup-20240127-150230/
│   └── ...
└── safety-backup-20240127-160145/
    └── ...
```

## 🔧 Installation

### Installation Complète
```bash
./install.sh
```

Le script créera automatiquement une sauvegarde globale de toutes vos configurations existantes avant l'installation.

### Options d'Installation
1. **Installation complète** (recommandé) - Sauvegarde + Installation + Dépendances + Thème
2. **Installation des configurations seulement** - Sauvegarde + Installation
3. **Installation des dépendances seulement**
4. **Application du thème par défaut seulement**

## 🔄 Restauration

### Menu Interactif
```bash
./restore.sh
```

Affiche un menu avec toutes les sauvegardes disponibles et leurs détails.

### Restauration Directe
```bash
./restore.sh 20240127-143052
```

Restaure directement la sauvegarde spécifiée par son timestamp.

### Commandes de Gestion

#### Lister les Sauvegardes
```bash
./restore.sh list
```

#### Afficher les Détails
```bash
./restore.sh details 20240127-143052
```

#### Supprimer une Sauvegarde
```bash
./restore.sh delete 20240127-143052
```

#### Nettoyer les Anciennes Sauvegardes
```bash
./restore.sh cleanup
```
Supprime automatiquement les sauvegardes les plus anciennes (garde les 5 plus récentes).

#### Aide
```bash
./restore.sh help
```

## 🛡️ Sécurité

### Sauvegarde de Sécurité
Avant chaque restauration, le script crée automatiquement une sauvegarde de sécurité de vos configurations actuelles. Cette sauvegarde est nommée `safety-backup-<timestamp>` et peut être utilisée pour annuler une restauration.

### Exemple de Flux de Sécurité
1. Vous restaurez une sauvegarde du 27/01 à 14:30
2. Le script crée automatiquement `safety-backup-20240127-160145`
3. Si vous voulez annuler : `./restore.sh 20240127-160145`

## 📋 Configurations Gérées

Le système sauvegarde et restaure automatiquement :

- **Applications de Terminal** : foot, kitty
- **Éditeurs** : nvim
- **Gestionnaires de Fenêtres** : sway, hypr
- **Barres de Statut** : waybar
- **Lanceurs** : wofi
- **Sécurité** : swaylock
- **Notifications** : mako
- **Système** : fastfetch
- **Scripts Utilitaires** : hotfiles-scripts

## 🔍 Informations de Sauvegarde

Chaque sauvegarde contient un fichier `backup-info.txt` avec :
- Date et heure de création
- Timestamp unique
- Script utilisé pour la création
- Liste des configurations sauvegardées
- Répertoire source

## ⚠️ Notes Importantes

1. **Redémarrage Requis** : Après une restauration, redémarrez votre session pour appliquer tous les changements.

2. **Format des Timestamps** : Les timestamps suivent le format `YYYYMMDD-HHMMSS` (ex: `20240127-143052`).

3. **Espace Disque** : Les sauvegardes peuvent occuper de l'espace. Utilisez `./restore.sh cleanup` régulièrement.

4. **Permissions** : Assurez-vous que les scripts sont exécutables (`chmod +x install.sh restore.sh`).

## 🐛 Dépannage

### Problème : "Sauvegarde non trouvée"
- Vérifiez que le timestamp est correct avec `./restore.sh list`
- Assurez-vous que le répertoire `~/.config-backups` existe

### Problème : "Permission denied"
- Rendez les scripts exécutables : `chmod +x install.sh restore.sh`

### Problème : Configurations non restaurées
- Vérifiez les permissions du répertoire `~/.config`
- Redémarrez votre session après la restauration

## 📞 Support

Pour signaler un problème ou suggérer une amélioration, créez une issue dans le dépôt du projet.

---

**Version** : 2.0  
**Dernière mise à jour** : Janvier 2024
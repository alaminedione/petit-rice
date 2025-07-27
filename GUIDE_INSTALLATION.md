# Guide d'Installation des Dotfiles

Ce guide explique en détail le fonctionnement du script `install.sh`, ses différentes options et comment l'exécuter pour configurer votre environnement Linux avec ces dotfiles.

## 🚀 À Propos du Script `install.sh`

Le script `install.sh` est un outil d'automatisation conçu pour simplifier le déploiement de cette configuration de dotfiles sur votre système. Il gère la sauvegarde de vos configurations existantes, l'installation des nouvelles configurations, la gestion des dépendances logicielles, l'application du thème par défaut et l'exécution de scripts de configuration supplémentaires.

L'objectif est de fournir un processus d'installation rapide, fiable et interactif.

## 🛠️ Fonctionnalités Principales

Le script `install.sh` effectue les opérations suivantes :

1.  **Sauvegarde Globale des Configurations Existantes** :
    *   Avant toute installation, le script vérifie la présence de configurations existantes pour les applications couvertes (foot, kitty, nvim, sway, swaylock, waybar, wofi, mako, fastfetch, hypr) ainsi que certains fichiers du répertoire `$HOME` (`.aliases.sh`, `.fdignore`, `.tgpt_aliases.sh`, `.vimrc`, `.viminfo`, `.vim`).
    *   Si des configurations sont trouvées, une sauvegarde horodatée est créée dans `$HOME/.config-backups/backup-YYYYMMDD-HHMMSS/`. Cela garantit que vous pouvez toujours revenir à votre état précédent.
    *   Un fichier `backup-info.txt` est inclus dans chaque sauvegarde, détaillant son contenu.

2.  **Installation des Configurations des Applications** :
    *   Les dossiers de configuration des applications (`foot`, `kitty`, `nvim`, `sway`, `swaylock`, `waybar`, `wofi`, `mako`, `fastfetch`, `hypr`) sont copiés depuis le répertoire du dépôt vers `$HOME/.config/`.
    *   Les configurations existantes pour ces applications sont supprimées avant la copie pour assurer une installation propre.

3.  **Installation des Fichiers du Répertoire `$HOME`** :
    *   Les fichiers et dossiers contenus dans le répertoire `home/` du dépôt (ex: `.vimrc`, `.zshrc`, `.aliases.sh`, `.vim/`) sont copiés directement dans votre répertoire `$HOME`.

4.  **Rendre les Scripts Exécutables** :
    *   Tous les scripts shell (`.sh`) trouvés dans le répertoire `scripts/` du dépôt sont rendus exécutables (`chmod +x`).

5.  **Installation des Scripts Utilitaires** :
    *   Les scripts du répertoire `scripts/` sont copiés dans `$HOME/.config/hotfiles-scripts/` pour les rendre facilement accessibles depuis votre système.

6.  **Installation des Dépendances (Optionnel)** :
    *   Le script peut exécuter `scripts/install-apps.sh` pour installer les applications et paquets nécessaires au bon fonctionnement de l'environnement. Une confirmation vous sera demandée.

7.  **Application du Thème par Défaut (Optionnel)** :
    *   Le script peut appliquer le thème `Catppuccin Mocha` en exécutant `scripts/change-theme/set-mocha.sh`. Une confirmation vous sera demandée.

8.  **Exécution de Scripts de Configuration Supplémentaires (Optionnel)** :
    *   Le script propose d'exécuter plusieurs scripts optionnels pour des configurations spécifiques (ex: correction des polices, configuration de Zsh, installation des curseurs, etc.). Chaque exécution nécessite une confirmation.

## ⚙️ Options d'Installation

Lorsque vous exécutez `./install.sh`, un menu interactif vous sera présenté avec les options suivantes :

1.  **Installation complète (recommandé)** :
    *   Exécute toutes les étapes : Sauvegarde globale, installation des configurations, installation des dépendances, application du thème par défaut, et exécution des scripts supplémentaires.
    *   C'est l'option la plus simple pour une première installation complète.

2.  **Installation des configurations seulement** :
    *   Effectue la sauvegarde globale et installe uniquement les configurations des applications et les fichiers du répertoire `$HOME`.
    *   Utile si vous avez déjà géré les dépendances.

3.  **Installation des dépendances seulement** :
    *   Exécute uniquement le script `scripts/install-apps.sh` pour installer les applications et paquets nécessaires.
    *   Utile si vous souhaitez gérer l'installation des configurations et du thème séparément.

4.  **Application du thème par défaut seulement** :
    *   Exécute uniquement le script `scripts/change-theme/set-mocha.sh` pour appliquer le thème par défaut.
    *   Utile si vous avez déjà installé les configurations et les dépendances.

5.  **Quitter** :
    *   Permet de sortir du script sans effectuer d'opérations.

## 🚀 Comment Exécuter le Script

Pour exécuter le script `install.sh`, suivez ces étapes :

1.  **Cloner le dépôt** (si ce n'est pas déjà fait) :
    ```bash
    git clone https://github.com/alaminedione/hotfiles.git
    cd hotfiles
    ```

2.  **Rendre le script exécutable** :
    ```bash
    chmod +x install.sh
    ```

3.  **Lancer le script** :
    ```bash
    ./install.sh
    ```

    Le menu interactif s'affichera, vous permettant de choisir l'option d'installation souhaitée.

## ⚠️ Notes Importantes

*   **Exécution depuis le Répertoire du Dépôt** : Le script doit être exécuté depuis le répertoire racine du dépôt `hotfiles` (là où se trouve `install.sh`).
*   **Redémarrage de Session** : Après une installation complète, il est fortement recommandé de redémarrer votre session (ou votre système) pour que tous les changements prennent effet correctement.
*   **Permissions** : Assurez-vous d'avoir les permissions nécessaires pour installer des paquets et modifier les fichiers de configuration dans votre répertoire `$HOME`.
*   **Sauvegardes** : N'oubliez pas que le script crée des sauvegardes. En cas de problème, vous pouvez utiliser `restore.sh` pour revenir à un état précédent. Référez-vous à `README-backup-restore.md` pour plus de détails sur la restauration.


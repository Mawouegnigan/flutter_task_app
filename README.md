

# TaskFlow — Application mobile de gestion de tâches en équipe

TaskFlow est une application mobile Android développée en Flutter/Dart, pensée pour la gestion collaborative de tâches en équipe. Elle combine une interface intuitive, une synchronisation en temps réel via Firebase et un mode hors ligne pour rester opérationnel même sans connexion.

---

## Le contexte

Gérer des tâches en équipe implique plus que de simples listes — il faut pouvoir discuter, prioriser, filtrer et rester synchronisé. TaskFlow répond à ce besoin en centralisant tout : création, suivi, chat par tâche et notifications push, le tout dans une seule application.

---

## Fonctionnalités

**Authentification complète**, inscription avec photo de profil, vérification en temps réel de la disponibilité du username, indicateur de robustesse du mot de passe, connexion classique ou via Google (Firebase Auth) et réinitialisation de mot de passe directement dans l'app.

**Gestion des tâches**, création avec titre, description, catégorie, priorité et échéance. Modification, suppression avec confirmation, marquage comme terminée et navigation vers le détail complet.

**Organisation avancée**, recherche en temps réel, filtres par statut et catégorie, tri par priorité ou date et compteur de tâches affiché en temps réel.

**Chat par tâche**, chaque tâche dispose de sa propre conversation Firestore. Les messages apparaissent instantanément, les membres de l'équipe peuvent discuter simultanément sur la même tâche.

**Notifications push**, intégration Firebase Cloud Messaging (FCM) — les notifications arrivent même quand l'application est fermée.

**Mode hors ligne**, détection automatique du réseau via `connectivity_plus`. Quand la connexion est absente, les tâches sont chargées depuis le cache Hive local avec un bandeau orange d'indication. À la reconnexion, la synchronisation est automatique.

**Profil & Paramètres**, thème clair/sombre et langue FR/EN switchables en temps réel avec persistance locale. FAQ, CGU, politique de confidentialité et écran À propos intégrés.

---

## Architecture du projet

```
taskflow/
├── lib/
│   ├── main.dart                  # Point d'entrée
│   ├── config/
│   │   └── api_config.dart        # Configuration backend
│   ├── screens/                   # Pages de l'application
│   │   ├── auth/                  # Connexion, inscription
│   │   ├── tasks/                 # Liste, détail, création
│   │   ├── chat/                  # Chat par tâche
│   │   └── profile/               # Profil & paramètres
│   ├── widgets/                   # Composants réutilisables
│   ├── models/                    # Modèles de données
│   ├── providers/                 # Gestion d'état (Provider)
│   └── services/                  # API, Firebase, Hive
├── backend/                       # NestJS REST API
│   ├── src/
│   │   ├── auth/                  # Authentification JWT
│   │   ├── tasks/                 # CRUD tâches
│   │   └── users/                 # Gestion utilisateurs
│   └── database.sqlite            # Base de données locale
├── pubspec.yaml                   # Dépendances Flutter
└── README.md
```

---

## Stack technique

| Technologie | Rôle |
|---|---|
| Flutter / Dart | Application mobile Android |
| NestJS | Backend REST API |
| SQLite | Base de données backend |
| Firebase Firestore | Chat en temps réel |
| Firebase FCM | Notifications push |
| Firebase Auth | Connexion Google |
| Hive | Cache local offline |
| Provider | Gestion d'état Flutter |
| SharedPreferences | Persistance des préférences |
| JWT | Sécurité des requêtes API |
| share_plus | Partage de tâches |
| connectivity_plus | Détection réseau |

---

## Sécurité

Mots de passe hashés avec **bcrypt** côté backend, tokens JWT avec expiration de 7 jours, validation robuste du mot de passe côté Flutter et backend, vérification de disponibilité du username avant inscription.

---

## État du déploiement

- ✅ Frontend Flutter — fonctionnel
- ✅ Backend NestJS — fonctionnel en local
- 🚧 Déploiement cloud du backend — en cours
- 🚧 Publication sur Google Play Store — à venir

> Le backend tourne actuellement en local. L'application sera pleinement accessible en ligne après déploiement cloud.

---

## Accès

- 💻 Code source : [github.com/Mawouegnigan/flutter_task_ap](https://github.com/Mawouegnigan/flutter_task_ap)
- 🚧 Demo live : disponible après déploiement


---

Tu valides ? On peut ensuite attaquer le README de **eccsinaivodje** ou passer directement à LinkedIn et le portfolio.

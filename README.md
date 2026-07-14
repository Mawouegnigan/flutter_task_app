# Yoon — Application mobile de gestion de tâches en équipe

**Yoon** *(« le chemin » en wolof)* est une application mobile Android développée en Flutter, conçue pour la gestion collaborative de tâches en équipe. Elle combine authentification complète, chat en temps réel par tâche, notifications push et mode hors ligne.

Projet développé dans le cadre du programme **FORCE-N** (Université Numérique Cheikh Hamidou Kane × Mastercard Foundation), sous le mentorat du **Pr Papa Ngom** (FST/UCAD).

---

## Équipe

| Membre | Rôle |
|---|---|
| **Mawouégnigan Grégoire FANGNON** | Lead intégrateur — architecture, Git, backend, i18n |
| **Gloria KAHOBETE** | Développeuse Flutter |
| **Armel KEDEGUE** | Développeur Flutter |
| **Pr Papa Ngom** | Mentor — FST/UCAD |

---

## Fonctionnalités

- **Authentification complète** — inscription avec vérification par e-mail (code à 6 chiffres), photo de profil, vérification en temps réel de la disponibilité du nom d'utilisateur, indicateur de robustesse du mot de passe, connexion classique ou via Google (Firebase Auth)
- **Gestion des tâches** — création, modification, suppression, priorité, catégorie, échéance, statut
- **Organisation avancée** — recherche en temps réel, filtres par statut/catégorie, tri par priorité ou date
- **Chat par tâche** — conversation Firestore dédiée à chaque tâche, messages instantanés
- **Notifications push** — Firebase Cloud Messaging (FCM), même application fermée
- **Mode hors ligne** — détection réseau automatique (`connectivity_plus`), cache local Hive, bandeau d'indication, resynchronisation automatique à la reconnexion
- **Internationalisation FR/EN** — traduction complète et dynamique de l'interface, switch en temps réel
- **Thème clair/sombre**, persistance des préférences
- **Écrans légaux et support** — CGU, politique de confidentialité, FAQ intégrées

---

## Stack technique

| Côté | Technologie |
|---|---|
| **Frontend** | Flutter / Dart, Provider (état), Hive (cache offline), `connectivity_plus`, `share_plus` |
| **Backend** | NestJS, SQLite (dev), JWT, bcrypt |
| **Temps réel** | Firebase Firestore (chat) |
| **Notifications** | Firebase Cloud Messaging |
| **Authentification** | Firebase Auth (Google Sign-In), vérification e-mail (Nodemailer) |
| **Sécurité** | Mots de passe hashés (bcrypt), tokens JWT, validation robuste des entrées |

---

## Lancer le projet

### Prérequis
- Flutter (dernière version stable)
- Android Studio ou VS Code
- Node.js ≥ 18 LTS (backend)

### Frontend Flutter
```bash
git clone https://github.com/Mawouegnigan/flutter_task_app.git
cd flutter_task_app
flutter pub get
flutter run
```

### Backend NestJS
```bash
git clone https://github.com/aliounekanoute/task_apis.git
cd task_apis
git checkout with-auth
npm install
npm run start:dev
```

Documentation Swagger disponible sur `http://localhost:3000/api-docs` une fois le backend lancé.

---

## Architecture du projet

```
lib/
├── main.dart              # Point d'entrée
├── config/                # Configuration API
├── models/                # Modèles de données
├── providers/             # Gestion d'état (Provider)
├── services/               # API, Firebase, cache, notifications
├── utils/                  # Constantes, thème, traductions
└── views/
    ├── screens/            # Écrans de l'application
    ├── view/               # Vues réutilisables
    └── widgets/            # Widgets réutilisables
```

---

## État du projet

- ✅ Frontend Flutter — fonctionnel, testé sur appareil physique et émulateur
- ✅ Backend NestJS — fonctionnel en local, vérification e-mail opérationnelle
- ✅ Internationalisation FR/EN — complète sur les 19 écrans de l'application
- 🚧 Durcissement sécurité backend (validation des entrées, CORS, rate limiting) — en cours
- 🚧 Déploiement cloud du backend — à venir
- 🚧 Publication Google Play Store — à venir

---

## Liens

- **Backend API** : [github.com/aliounekanoute/task_apis](https://github.com/aliounekanoute/task_apis) — branche `with-auth`
- **Documentation API** : Swagger, `http://localhost:3000/api-docs` (backend local)

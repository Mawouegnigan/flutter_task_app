# TaskFlow — Application Flutter de gestion de tâches

## Équipe
| Membre | Rôle | Branche |
|--------|------|---------|
| A (Lead) | Intégration, stabilisation, merges | feature/integration-flow |
| B | UI, Auth, Responsive | feature/ui-auth |
| C | Navigation, API CRUD | feature/api-navigation |

## Version Flutter
- Version de référence : **Flutter 3.41.8 stable**
- Ne pas faire `flutter upgrade` sans accord du lead

## Lancer le projet

### Prérequis
- Flutter 3.41.8
- Android Studio ou VS Code
- Node.js >= 14.x (pour le backend)

### Frontend Flutter
```bash
git clone https://github.com/Mawouegnigan/flutter_task_app.git
cd flutter_task_app
flutter clean
flutter pub get
flutter run
```

### Backend NestJS
```bash
git clone https://github.com/aliounekanoute/task_apis.git
cd task_apis
git checkout with-auth
npm install
npx sequelize-cli db:migrate
npm run start
```

## Structure des branches
- `main` — branche stable, merge final uniquement par le lead
- `navigation` — travail Livrable 1
- `feature/integration-flow` — intégration Livrable 2 (Lead)
- `feature/ui-auth` — UI et Auth (B)
- `feature/api-navigation` — Navigation et CRUD API (C)

## Architecture du projet


lib/
├── config/          # Configuration API (URLs)
├── core/            # Exceptions et utilitaires partagés
├── data/            # Données mock
├── models/          # Modèles de données
├── routes/          # Routes de navigation
├── services/        # Services API (Auth, Tasks)
├── utils/           # Constantes et thème
└── views/
├── screens/     # Écrans de l'application
├── view/        # Vues réutilisables
└── widgets/     # Widgets réutilisables




## Écrans disponibles
- SplashScreen
- OnboardingScreen
- LoginScreen
- RegisterScreen
- HomeScreen
- TaskDetailScreen
- AddEditingTaskScreen
- ProfileScreen

## Workflow Git équipe
```bash
git checkout ma-branche
git pull origin ma-branche
# ... faire les modifications ...
git add .
git commit -m "message clair en anglais"
git push origin ma-branche
```

## Règles équipe
- 1 fonctionnalité = 1 branche
- Toujours `git pull` avant de travailler
- Ne jamais modifier `main.dart` sans le lead
- `main` est modifié uniquement par le lead
- Commits fréquents et messages clairs en anglais

## Backend API
- Repo : https://github.com/aliounekanoute/task_apis
- Branche utilisée : `with-auth`
- URL locale : `http://localhost:3000`
- Documentation Swagger : `http://localhost:3000/api-docs`

## Endpoints API
### Auth
- `POST /auths/register` — Inscription
- `POST /auths/login` — Connexion
- `GET /auths/profils` — Profil utilisateur

### Tâches
- `GET /tasks` — Liste des tâches
- `POST /tasks` — Créer une tâche
- `PUT /tasks/:id` — Modifier une tâche
- `DELETE /tasks/:id` — Supprimer une tâche
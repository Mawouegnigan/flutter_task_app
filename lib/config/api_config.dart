class ApiConfig {
  // URL de base du backend
  // À modifier selon l'environnement (local, production)
  static const String baseUrl = 'http://localhost:3000';

  // Endpoints Auth
  static const String register = '$baseUrl/auths/register';
  static const String login = '$baseUrl/auths/login';
  static const String profil = '$baseUrl/auths/profils';

  // Endpoints Tâches
  static const String tasks = '$baseUrl/tasks';
  static String taskById(int id) => '$baseUrl/tasks/$id';
}
class ApiConfig {
  // URL de base du backend
  static const String baseUrl = 'http://localhost:3000';

  // Endpoints Auth
  static const String register      = '$baseUrl/auths/register';
  static const String login         = '$baseUrl/auths/login';
  static const String profil        = '$baseUrl/auths/profils';
  static const String updateProfil  = '$baseUrl/auths/profils'; // PUT

  // Endpoints Tâches
  static const String tasks         = '$baseUrl/task';
  static String taskById(int id)    => '$baseUrl/task/$id';
}
class ApiConfig {
  // URL de base du backend
 static const String baseUrl = 'http://172.24.201.71:3000';

  // Endpoints Auth
  static const String register      = '$baseUrl/auths/register';
  static const String login         = '$baseUrl/auths/login';
  static const String profil        = '$baseUrl/auths/profils';
  static const String updateProfil  = '$baseUrl/auths/profils'; // PUT
  static const String sendCode      = '$baseUrl/auths/send-code';
  static const String verifyCode    = '$baseUrl/auths/verify-code';

  // Endpoints Tâches
  static const String tasks         = '$baseUrl/task';
  static String taskById(int id)    => '$baseUrl/task/$id';
}

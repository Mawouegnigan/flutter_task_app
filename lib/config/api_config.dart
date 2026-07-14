class ApiConfig {
  // URL de base du backend.
  // IMPORTANT : necessite "adb reverse tcp:3000 tcp:3000" avant de lancer
  // l'app sur telephone/emulateur connecte en USB (backend local sur ce port).
  // Sur emulateur SANS adb reverse, utiliser 10.0.2.2 au lieu de localhost.
  static const String baseUrl = 'http://localhost:3000';

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

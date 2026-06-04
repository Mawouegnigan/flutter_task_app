class FormValidator {
  
  /// Validation du nom d'utilisateur
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Le nom d'utilisateur est obligatoire.";
    }
    if (value.trim().length < 3) {
      return "Le nom d'utilisateur doit contenir au moins 3 caractères.";
    }
    return null; // Retourne null si le champ est valide
  }

  /// Validation de l'adresse Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "L'adresse email est obligatoire.";
    }
    
    // Expression régulière standard pour valider la structure d'un email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegex.hasMatch(value.trim())) {
      return "Veuillez saisir une adresse email valide.";
    }
    return null;
  }

  /// Validation du Mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Le mot de passe est obligatoire.";
    }
    
    // Vérification de la longueur Minimum 8 caractères
    if (value.length < 8) {
      return "Le mot de passe doit contenir \nau moins 8 caractères.";
    }

    // Vérification d'au moins une lettre majuscule
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Le mot de passe doit contenir \nau moins une majuscule.";
    }

    // Vérification d'au moins une lettre minuscule
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Le mot de passe doit contenir \nau moins une minuscule.";
    }

    // Vérification d'au moins un chiffre
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Le mot de passe doit contenir \nau moins un chiffre.";
    }
    
    // Vérification de caractere speciale
    if (!RegExp(r'[.!@#\$&*~]').hasMatch(value)) {
      return "Le mot de passe doit contenir \nau moins un caractère spécial (!@#\$&*~.).";
    }
    
    return null;
  }
}
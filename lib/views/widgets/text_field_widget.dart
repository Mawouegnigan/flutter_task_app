import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

/// Widget de champ de saisie personnalisé pour les écrans d'authentification (Login, Register)
///   conçu pour être réutilisé dans les écrans de connexion et d'inscription, offrant une apparence cohérente 
///   et des fonctionnalités adaptées aux champs de saisie tels que l'email et le mot de passe, nom d'utilisateur.
/// [label]: Le texte du label (ex: Email, Mot de passe)
/// [placeholder]: Le texte du placeholder (ex: Saisissez-votre mot de passe ici)
/// [prefixIcon]: l'icone a afficher à gauche du champs de saisie (ex: Icons.email, Icons.lock)
/// [isPassword]: un boolean pour determiner si le champs est un mot de passe 
///    (affiché l'icone de cadenas et l'icone pour cacher/afficher le mot de passe) ou un champs de saisie classique
/// [isPasswordVisible]: un boolean pour determiner si le mot de passe est visible ou caché
/// [onSuffixIconPressed]: une fonction à executer qd on clic sur l'icone de l'oeil (pour afficher ou cacher le mot de passe)
/// [controller]: pour gerer le texte saisie (ex: recuperer le text et le gerer au backend)
/// [validator]: Pour valider le chaps de saissie (ex: verifier que l'email est au bon format, que le mot de passe contient au moin 8 caracteres...)
/// 
class TextFieldWidget extends StatelessWidget {
  final String label, placeholder;
  final IconData prefixIcon;
  final bool isPassword, isPasswordVisible;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController controller; // Pour gérer le texte saisi
  final String? Function(String?)? validator; // Pour la validation du champ

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.placeholder,
    required this.prefixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onSuffixIconPressed,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,

      // Cacher le texte si c'est un champs mot de passe ET qu'il n'est pas configuré comme visible
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        // Sélectionne l'icône de cadenas si c'est un champs mot de passe, sinon l'icône fournie
        prefixIcon: Icon(isPassword ? Icons.lock_outline : prefixIcon),

        // Affiche l'icône de l'oeil si c'est un champs mot de passe, sinon rien
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
        label: Text(label),
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: AppColors.textDarkSecondary,
        ),

        // style pour le champs de saisie en etat normal
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.textDarkSecondary, width: 2),
        ),

        // style pour le champs de saisie en etat focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),

        // style pour le champs de saisie erreur
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

        // style pour focus sur le champs de saisie erreur
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

/// Widget de champ de saisie personnalisé pour les écrans d'authentification (Login, Register)
/// Affiche un label au dessus du champ de saisie et un placeholder à l'intérieur du champ
/// [label]: Le texte du label (ex: Email, Mot de passe)
/// [placeholder]: Le texte du placeholder (ex: Saisissez-votre mot de passe ici)
class TextFieldWidget extends StatelessWidget {
  final String label, placeholder;
  final bool isPassword;
  // final TextEditingController controller; // Pour gérer le texte saisi
  // final String? Function(String?)? validator; // Pour la validation du champ

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label du champ de saisie
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),

        // le champ de saisie avec placeholder
        TextFormField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: const TextStyle(
              color: AppColors.textDarkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

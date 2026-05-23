import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/utils/constants.dart';

/// Widget d'entete pour les écrans d'authentification (Login, Register)
///  Affiche le logo de TaskFlow, un titre et un sous-titre de bienvenue
/// [title] : Le titre principal (ex: "Bienvenue sur TaskFlow")
/// [subtitle] : Le texte de bienvenue secondaire (ex: "Gérez vos tâches efficacement")
class AuthHeaderView extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeaderView({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Logo de TaskFolw
        SvgPicture.asset(
          'assets/images/task_flow_logo.svg',
          width: 280,
        ),
        const SizedBox(height: 20),

        // Titre et subtitle de bienvenue
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textDarkSecondary,
          ),
        ),
      ],
    );
  }
}

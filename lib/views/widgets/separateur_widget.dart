import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

// -------------------OU-------------------
class SeparateurWidget extends StatelessWidget {
  const SeparateurWidget({ super.key });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ligne de gauche
        const Expanded(
          child: Divider(
            thickness: 1, 
            color: AppColors.textDarkSecondary, 
          ),
        ),

        // Texte central
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "OU",
            style: const TextStyle(
              color: AppColors.textDarkSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),

        // Ligne de droite
        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppColors.textDarkSecondary,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class ProfileHeaderView extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeaderView({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar + Borrder + Camera Button
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Borrder vert
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2F6B3D),
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  size: 75,
                  color: Colors.white,
                ),
              ),
            ),

            // Bouton caméra
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F6B3D),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    // Action changer photo
                  },
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Nom
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.textDarkPrimary,
          ),
        ),

        // Email
        Text(
          email,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),

        // Bouton Modifier Profil
        ElevatedButton(
          onPressed: () {}, // A definir navigation vers la page edit profile
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black12,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Modifier Profil",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textDarkPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
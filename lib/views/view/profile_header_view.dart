import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/edit_profile_screen.dart';

class ProfileHeaderView extends StatelessWidget {
  final String name;
  final String email;
  final String? username;
  final String? photoUrl;

  const ProfileHeaderView({
    super.key,
    required this.name,
    required this.email,
    this.username,
    this.photoUrl,
  });

  /// Extrait les initiales depuis le nom complet
  /// "admin gregoire" → "AG"
  String get _initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Affiche l'email si valide, sinon le username
  String get _displayEmail {
    final emailVal = email.trim();
    final hasAt = emailVal.contains('@');
    if (emailVal.isNotEmpty && hasAt) return emailVal;
    if (username != null && username!.isNotEmpty) return '@$username';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Avatar ────────────────────────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Bordure verte
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                    ? NetworkImage(photoUrl!)
                    : null,
                onBackgroundImageError: (photoUrl != null && photoUrl!.isNotEmpty)
                    ? (_, __) {} // fallback sur les initiales si image cassée
                    : null,
                child: (photoUrl == null || photoUrl!.isEmpty)
                    ? Text(
                        _initials,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),

            // Bouton caméra
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
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
                    // TODO : image picker
                  },
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ── Nom ───────────────────────────────────────────────────
        Text(
          name.isEmpty ? 'Utilisateur' : name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textDarkPrimary,
          ),
        ),

        const SizedBox(height: 4),

        // ── Email ou username ─────────────────────────────────────
        if (_displayEmail.isNotEmpty)
          Text(
            _displayEmail,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDarkSecondary,
            ),
          ),

        const SizedBox(height: 16),

        // ── Bouton Modifier Profil ────────────────────────────────
        ElevatedButton.icon(
            onPressed: () async {
            final updated = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(
                  initialNom:      name,
                  initialPrenom:   name,
                  initialEmail:    email,
                  initialPhotoUrl: photoUrl,
                ),
              ),
            );
          },
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text("Modifier le profil"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textDarkPrimary,
            elevation: 2,
            shadowColor: Colors.black12,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
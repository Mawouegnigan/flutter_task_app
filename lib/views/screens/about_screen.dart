import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Logo + nom ───────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'TaskFlow',
                  style: TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.textDarkSecondary.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Description ──────────────────────────────────────────
          _SectionTitle(label: 'Description'),
          const SizedBox(height: 8),
          _InfoCard(
            content:
                'TaskFlow est une application de gestion de tâches en équipe, développée dans le cadre d\'un projet académique. Elle permet de créer, organiser, partager et suivre des tâches en temps réel.',
          ),

          const SizedBox(height: 20),

          // ── Équipe ───────────────────────────────────────────────
          _SectionTitle(label: 'Équipe de développement'),
          const SizedBox(height: 8),
          _TeamCard(
            name: 'Ezéchiel Mawouegnigan',
            role: 'Lead & Intégrateur\nPartage, Profil & Paramètres',
            icon: Icons.integration_instructions_outlined,
          ),
          const SizedBox(height: 4),
          _TeamCard(
            name: 'Membre B',
            role: 'Cache local & Mode hors ligne',
            icon: Icons.storage_outlined,
          ),
          const SizedBox(height: 4),
          _TeamCard(
            name: 'Lead Firebase',
            role: 'Notifications push & Chat en temps réel',
            icon: Icons.notifications_outlined,
          ),

          const SizedBox(height: 20),

          // ── Repo ─────────────────────────────────────────────────
          _SectionTitle(label: 'Dépôt source'),
          const SizedBox(height: 8),
          _InfoCard(
            content: 'github.com/Mawouegnigan/flutter_task_app',
            icon: Icons.code,
          ),

          const SizedBox(height: 20),

          // ── Stack technique ──────────────────────────────────────
          _SectionTitle(label: 'Technologies utilisées'),
          const SizedBox(height: 8),
          _InfoCard(
            content: 'Flutter • Dart • NestJS • SQLite\nFirebase • Hive • Provider',
          ),
        ],
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textDarkSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String content;
  final IconData? icon;
  const _InfoCard({required this.content, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textDarkSecondary.withValues(alpha: 0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                content,
                style: TextStyle(
                  color: AppColors.textDarkSecondary.withValues(alpha: 0.9),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Team card ─────────────────────────────────────────────────────────────────
class _TeamCard extends StatelessWidget {
  final String name;
  final String role;
  final IconData icon;
  const _TeamCard({required this.name, required this.role, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textDarkSecondary.withValues(alpha: 0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          role,
          style: TextStyle(
            color: AppColors.textDarkSecondary.withValues(alpha: 0.7),
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
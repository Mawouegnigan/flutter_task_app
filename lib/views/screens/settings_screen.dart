import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/providers/app_settings_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Thème ───────────────────────────────────────────────
          _SectionTitle(label: 'Apparence'),
          const SizedBox(height: 8),
          _SettingCard(
            icon: Icons.dark_mode_outlined,
            title: 'Mode sombre',
            subtitle: settings.isDarkMode ? 'Activé' : 'Désactivé',
            trailing: Switch(
              value: settings.isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (val) => settings.toggleTheme(val),
            ),
          ),

          const SizedBox(height: 20),

          // ── Langue ──────────────────────────────────────────────
          _SectionTitle(label: 'Langue'),
          const SizedBox(height: 8),
          _SettingCard(
            icon: Icons.language_outlined,
            title: 'Langue de l\'application',
            subtitle: settings.languageCode == 'fr' ? 'Français' : 'English',
            trailing: DropdownButton<String>(
              value: settings.languageCode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'fr', child: Text('FR')),
                DropdownMenuItem(value: 'en', child: Text('EN')),
              ],
              onChanged: (val) {
                if (val != null) settings.setLanguage(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section title ────────────────────────────────────────────────────────────
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

// ── Setting card ─────────────────────────────────────────────────────────────
class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

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
          title,
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textDarkSecondary.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
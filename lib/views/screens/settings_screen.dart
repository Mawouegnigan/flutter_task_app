import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/providers/app_settings_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/categories_settings_screen.dart';
import 'package:flutter_task_app/utils/translations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings_title'.tr(context)),
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
          _SectionTitle(label: 'settings_appearance'.tr(context)),
          const SizedBox(height: 8),
          _SettingCard(
            icon: Icons.dark_mode_outlined,
            title: 'settings_dark_mode'.tr(context),
            subtitle: settings.isDarkMode
                ? 'settings_enabled'.tr(context)
                : 'settings_disabled'.tr(context),
            trailing: Switch(
              value: settings.isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (val) => settings.toggleTheme(val),
            ),
          ),

          const SizedBox(height: 20),

          // ── Langue ──────────────────────────────────────────────
          _SectionTitle(label: 'settings_language'.tr(context)),
          const SizedBox(height: 8),
          _SettingCard(
            icon: Icons.language_outlined,
            title: 'settings_app_language'.tr(context),
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

          const SizedBox(height: 20),

          // ── Mode hors ligne ──────────────────────────────────────
          _SectionTitle(label: 'settings_network'.tr(context)),
          const SizedBox(height: 8),
          _SettingCard(
            icon: Icons.wifi_off_outlined,
            title: 'settings_offline_mode'.tr(context),
            subtitle: settings.isManualOffline
                ? 'settings_offline_active'.tr(context)
                : 'settings_offline_inactive'.tr(context),
            trailing: Switch(
              value: settings.isManualOffline,
              activeColor: AppColors.primary,
              onChanged: (val) => settings.toggleOfflineMode(val),
            ),
          ),

          const SizedBox(height: 20),

          // ── Catégories ──────────────────────────────────────────
          _SectionTitle(label: 'settings_tasks_section'.tr(context)),
          const SizedBox(height: 8),
          _SettingCard(
            icon: Icons.category_outlined,
            title: 'settings_categories'.tr(context),
            subtitle: 'settings_categories_subtitle'.tr(context),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary(context),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesSettingsScreen(),
                ),
              );
            },
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
      style: TextStyle(
        color: AppColors.textSecondary(context),
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
  final VoidCallback? onTap;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textSecondary(context).withValues(alpha: 0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
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
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textSecondary(context).withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
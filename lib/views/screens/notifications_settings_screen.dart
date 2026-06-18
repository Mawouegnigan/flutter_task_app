import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _taskReminders = true;
  bool _deadlineAlerts = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notif_enabled') ?? true;
      _taskReminders = prefs.getBool('notif_reminders') ?? true;
      _deadlineAlerts = prefs.getBool('notif_deadlines') ?? true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Global ──────────────────────────────────────────────
          _SectionTitle(label: 'Général'),
          const SizedBox(height: 8),
          _ToggleCard(
            icon: Icons.notifications_outlined,
            title: 'Activer les notifications',
            subtitle: 'Recevoir toutes les alertes de l\'app',
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              _save('notif_enabled', val);
            },
          ),

          const SizedBox(height: 20),

          // ── Détail ──────────────────────────────────────────────
          _SectionTitle(label: 'Types de notifications'),
          const SizedBox(height: 8),
          _ToggleCard(
            icon: Icons.alarm_outlined,
            title: 'Rappels de tâches',
            subtitle: 'Alertes avant l\'échéance d\'une tâche',
            value: _taskReminders && _notificationsEnabled,
            enabled: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _taskReminders = val);
              _save('notif_reminders', val);
            },
          ),
          const SizedBox(height: 1),
          _ToggleCard(
            icon: Icons.warning_amber_outlined,
            title: 'Alertes d\'échéance',
            subtitle: 'Notification quand une tâche est en retard',
            value: _deadlineAlerts && _notificationsEnabled,
            enabled: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _deadlineAlerts = val);
              _save('notif_deadlines', val);
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
      style: const TextStyle(
        color: AppColors.textDarkSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Toggle card ──────────────────────────────────────────────────────────────
class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textDarkSecondary.withValues(alpha: 0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: enabled ? AppColors.primary : AppColors.textDarkSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled
                ? AppColors.textDarkPrimary
                : AppColors.textDarkSecondary,
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
        trailing: Switch(
          value: value,
          activeColor: AppColors.primary,
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}
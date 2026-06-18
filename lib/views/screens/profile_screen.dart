import 'package:flutter/material.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/about_screen.dart';
import 'package:flutter_task_app/views/screens/legal_screen.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/screens/notifications_settings_screen.dart';
import 'package:flutter_task_app/views/screens/settings_screen.dart';
import 'package:flutter_task_app/views/screens/support_screen.dart';
import 'package:flutter_task_app/views/view/profile_header_view.dart';
import 'package:flutter_task_app/views/widgets/logout_button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name     = '';
  String _email    = '';
  String _username = '';
  String? _photoUrl;
  bool _isLoading  = true;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    try {
      final profil = await AuthService.getProfil();
      if (mounted && profil != null) {
        setState(() {
          _name     = '${profil['prenom'] ?? ''} ${profil['nom'] ?? ''}'.trim();
          _email    = profil['email']    ?? '';
          _username = profil['username'] ?? '';
          _photoUrl = profil['photo'] as String?;
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigate(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _navigate(const NotificationsSettingsScreen()),
            icon: const Icon(Icons.notifications_outlined),
            padding: const EdgeInsets.all(10),
            iconSize: 26,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // ── En-tête profil ──────────────────────────────
                  ProfileHeaderView(
                    name:     _name.isEmpty ? 'Utilisateur' : _name,
                    email:    _email,
                    username: _username,
                    photoUrl: _photoUrl,
                  ),

                  const SizedBox(height: 24),

                  // ── Paramètres généraux ─────────────────────────
                  _CardItem(
                    icon: Icons.settings_outlined,
                    title: 'Paramètres',
                    subtitle: 'Stockage, langue, thème, police',
                    onTap: () => _navigate(const SettingsScreen()),
                  ),

                  const SizedBox(height: 8),

                  // ── Groupe Tâches ───────────────────────────────
                  _CardGroup(
                    items: [
                      _CardItemData(
                        icon: Icons.bookmarks_outlined,
                        title: 'Catégorie & Priorité',
                        subtitle: 'Gérer vos catégories de tâches',
                        onTap: () {},
                      ),
                      _CardItemData(
                        icon: Icons.notifications_outlined,
                        title: 'Rappels & Notifications',
                        subtitle: 'Alertes, fréquence, heure de rappel',
                        onTap: () => _navigate(const NotificationsSettingsScreen()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── Groupe Aide ─────────────────────────────────
                  _CardGroup(
                    items: [
                      _CardItemData(
                        icon: Icons.info_outline_rounded,
                        title: 'Conditions & Confidentialité',
                        subtitle: 'CGU, politique de confidentialité',
                        onTap: () => _navigate(const LegalScreen()),
                      ),
                      _CardItemData(
                        icon: Icons.shield_outlined,
                        title: 'Aide & Support',
                        subtitle: 'FAQ, contacter le support',
                        onTap: () => _navigate(const SupportScreen()),
                      ),
                      _CardItemData(
                        icon: Icons.help_outline_rounded,
                        title: 'À propos',
                        subtitle: "Version de l'application V1.0.0",
                        onTap: () => _navigate(const AboutScreen()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Déconnexion ─────────────────────────────────
                  LogoutButtonWidget(
                    onConfirm: () async {
                      await AuthService.logout();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

// ── CardItem data model ──────────────────────────────────────────────────────
class _CardItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _CardItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

// ── Groupe de cards avec bords arrondis enchaînés ────────────────────────────
class _CardGroup extends StatelessWidget {
  final List<_CardItemData> items;
  const _CardGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isFirst = i == 0;
        final isLast  = i == items.length - 1;
        return Column(
          children: [
            _CardItem(
              icon:      item.icon,
              title:     item.title,
              subtitle:  item.subtitle,
              onTap:     item.onTap,
              topRadius: isFirst ? 16 : 4,
              btmRadius: isLast  ? 16 : 4,
            ),
            if (!isLast) const SizedBox(height: 1),
          ],
        );
      }),
    );
  }
}

// ── Card individuelle ────────────────────────────────────────────────────────
class _CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double topRadius;
  final double btmRadius;

  const _CardItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.topRadius = 16,
    this.btmRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textDarkSecondary.withValues(alpha: 0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top:    Radius.circular(topRadius),
          bottom: Radius.circular(btmRadius),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.textDarkSecondary,
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
              height: 1.4,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textDarkSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_task_app/services/google_auth_service.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';
import 'package:flutter_task_app/views/widgets/separateur_widget.dart';
import 'package:flutter_task_app/views/widgets/social_auth_button_widget.dart';

class SocialAuthSectionView extends StatefulWidget {
  final bool isLoginScreen;
  const SocialAuthSectionView({super.key, required this.isLoginScreen});

  @override
  State<SocialAuthSectionView> createState() => _SocialAuthSectionViewState();
}

class _SocialAuthSectionViewState extends State<SocialAuthSectionView> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await GoogleAuthService.signInWithGoogle();
      if (!mounted) return;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('social_google_success'.tr(context,
                title: user.displayName ?? user.email ?? '')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('social_google_cancelled'.tr(context)),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'social_error'.tr(context)}$e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SeparateurWidget(),
        const SizedBox(height: 10),
        Column(
          children: [
            // Google
            _isLoading
                ? const CircularProgressIndicator()
                : SocialAuthButtonWidget(
                    label: widget.isLoginScreen
                        ? 'social_login_google'.tr(context)
                        : 'social_register_google'.tr(context),
                    icon: "assets/images/google-logo.svg",
                    onPressed: _handleGoogleSignIn,
                  ),
          ],
        ),
      ],
    );
  }
}
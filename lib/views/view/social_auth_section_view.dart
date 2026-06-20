import 'package:flutter/material.dart';
import 'package:flutter_task_app/services/google_auth_service.dart';
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
            content: Text('Connecté en tant que ${user.displayName ?? user.email}'),
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
          const SnackBar(
            content: Text('Connexion Google annulée'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
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
                        ? "Se connecter avec Google"
                        : "S'inscrire avec Google",
                    icon: "assets/images/google-logo.svg",
                    onPressed: _handleGoogleSignIn,
                  ),
            const SizedBox(height: 10),

            // Facebook — désactivé
            SocialAuthButtonWidget(
              label: widget.isLoginScreen
                  ? "Se connecter avec Facebook"
                  : "S'inscrire avec Facebook",
              icon: "assets/images/facebook-logo.svg",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Facebook non disponible pour le moment'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
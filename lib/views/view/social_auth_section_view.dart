import 'package:flutter/material.dart';
import 'package:flutter_task_app/views/widgets/separateur_widget.dart';
import 'package:flutter_task_app/views/widgets/social_auth_button_widget.dart';

/// Section avec des boutton de connection comme Google, Facebook,...
/// Le paramètre [isLoginScreen] permet de différencier les textes des boutton selon l'écran (Login ou Register)
/// Exemple : "Se connecter avec Google" pour l'écran de Login et "S'inscrire avec Google" pour l'écran de Register
class SocialAuthSectionView extends StatelessWidget {
  final bool isLoginScreen;
  const SocialAuthSectionView({super.key, required this.isLoginScreen});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Separateur "OU"
      const SeparateurWidget(),
      const SizedBox(height: 10),

      // Boutton de connectionn sociale Google et Facebook
      Column(children: [
        // Google
        SocialAuthButtonWidget(
          label: isLoginScreen
              ? "Se connecter avec Google"
              : "S'inscrire avec Google",
          icon: "assets/images/google-logo.svg",
          onPressed: () {},
        ),
        const SizedBox(height: 10),

        // // Faacebook
        SocialAuthButtonWidget(
          label: isLoginScreen
              ? "Se connecter avec Facebook"
              : "S'inscrire avec Facebook",
          icon: "assets/images/facebook-logo.svg",
          onPressed: () {},
        ),
      ])
    ]);
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/views/screens/onboarding_screen.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;
    final hasToken = await AuthService.isLoggedIn();

    // Un token present localement ne garantit pas qu'il est encore valide
    // cote serveur (expire, ou utilisateur inexistant apres changement de
    // base). On verifie donc aupres du backend avant de sauter directement
    // a l'accueil, sinon l'app pourrait "choisir" un ancien compte par
    // defaut sans jamais laisser la main sur l'ecran de connexion.
    // Si le serveur est injoignable (hors ligne), on garde la session pour
    // ne pas casser le mode offline.
    bool isLoggedIn = false;
    if (hasToken) {
      final tokenValid = await AuthService.checkTokenValid();
      if (tokenValid == false) {
        await AuthService.logout();
        isLoggedIn = false;
      } else {
        // true (valide) ou null (hors ligne) → on reste connecte
        isLoggedIn = true;
      }
    }

    if (!mounted) return;

    Widget destination;
    if (!onboardingDone) {
      // Premier lancement → onboarding
      destination = const OnboardingScreen();
    } else if (isLoggedIn) {
      // Déjà connecté → accueil directement
      destination = const HomeScreen();
    } else {
      // Onboarding vu mais pas connecté → login
      destination = const LoginScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/task_flow_logo.svg",
                width: 250,
              ),
              const SizedBox(height: 20),
              Text(
                'splash_tagline'.tr(context),
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

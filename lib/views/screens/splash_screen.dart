import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/views/screens/onboarding_screen.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    // Vérifier si l'utilisateur est déjà connecté
    final isLoggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomeScreen() : const OnboardingScreen(),
      ),
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
                "Organisez vos tâches facilement",
                style: TextStyle(
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
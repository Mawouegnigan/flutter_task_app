import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const SizedBox(height: 20),

              // IMAGE
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/onboarding_illusrtation_1.svg",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TITRE + DESCRIPTION
              Column(
                children: const [
                  Text(
                    'Prenez le contrôle de votre journée',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Votre productivité, simplifiée. Organisez vos tâches, planifiez vos journées et capturez vos idées sans effort.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BOUTON
              CtaButtonWidget(
                text: "Démarrer",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
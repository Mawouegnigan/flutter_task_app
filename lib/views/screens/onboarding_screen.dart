import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

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
                children: [
                  Text(
                    'onboarding_title_main'.tr(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'onboarding_desc_main'.tr(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BOUTON
              CtaButtonWidget(
                text: 'onboarding_start'.tr(context),
                onPressed: () => _finish(context),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

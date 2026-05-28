import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';
import 'package:flutter_task_app/views/screens/register_screen.dart';
import 'package:flutter_task_app/views/view/auth_header_view.dart';
import 'package:flutter_task_app/views/view/social_auth_section_view.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header de bienvenue
              AuthHeaderView(
                title: "Bon retour !",
                subtitle:
                    "Connectez-vous à votre espace et organisez votre journée en un clic.",
              ),
              SizedBox(height: 30),

              // Formulaire de connexion
              Form(
                child: Column(
                  children: [
                    // Champ email
                    TextFieldWidget(
                      label: "Email",
                      placeholder: "John.doe@exemple.com",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 30),

                    // Champ mot de passe avec visibilité gérée
                    TextFieldWidget(
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      label: "Mot de passe",
                      placeholder: "Saisissez votre mot de passe ici",
                      prefixIcon: Icons.lock_outline,
                    ),
                    SizedBox(height: 12),

                    // Lien mot de passe oublié
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                            color: AppColors.textDarkSecondary,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Bouton de connexion
                    CtaButtonWidget(
                      text: "Se Connecter",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Section connexion sociale
              SocialAuthSectionView(isLoginScreen: true),
              SizedBox(height: 30),

              // Lien vers inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pas encore de compte ? "),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Inscrivez-vous",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
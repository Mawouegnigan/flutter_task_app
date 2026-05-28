import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/view/auth_header_view.dart';
import 'package:flutter_task_app/views/view/social_auth_section_view.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header de bienvenue
              AuthHeaderView(
                title: "Bienvenue parmi nous !",
                subtitle:
                    "Créez votre espace personnel pour organiser vos projets en toute simplicité.",
              ),
              SizedBox(height: 30),

              // Formulaire d'inscription
              Form(
                child: Column(
                  children: [
                    // Champ nom d'utilisateur
                    TextFieldWidget(
                      label: "Nom d'utilisateur",
                      placeholder: "John DOE",
                      prefixIcon: Icons.person_outline,
                    ),
                    SizedBox(height: 20),

                    // Champ email
                    TextFieldWidget(
                      label: "Email",
                      placeholder: "John.doe@exemple.com",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 20),

                    // Champ mot de passe avec visibilité
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
                    SizedBox(height: 20),

                    // Champ confirmation mot de passe
                    TextFieldWidget(
                      isPassword: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      label: "Confirmer le mot de passe",
                      placeholder: "Confirmez votre mot de passe",
                      prefixIcon: Icons.lock_outline,
                    ),
                    SizedBox(height: 20),

                    // Bouton d'inscription
                    CtaButtonWidget(
                      text: "S'inscrire",
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
              SizedBox(height: 10),

              // Section connexion sociale
              SocialAuthSectionView(isLoginScreen: false),
              SizedBox(height: 20),

              // Lien vers connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Déjà membre ? "),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Connectez-vous ici",
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
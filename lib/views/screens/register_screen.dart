import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/services/auth_service.dart';
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
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation des champs vides
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Validation confirmation mot de passe
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.register(
        username: username,
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès !')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création du compte')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion au serveur')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                      controller: _usernameController,
                    ),
                    SizedBox(height: 20),

                    // Champ email
                    TextFieldWidget(
                      label: "Email",
                      placeholder: "John.doe@exemple.com",
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
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
                      controller: _passwordController,
                    ),
                    SizedBox(height: 20),

                    // Champ confirmation mot de passe
                    TextFieldWidget(
                      isPassword: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                      label: "Confirmer le mot de passe",
                      placeholder: "Confirmez votre mot de passe",
                      prefixIcon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: 20),

                    // Bouton d'inscription
                    _isLoading
                        ? const CircularProgressIndicator()
                        : CtaButtonWidget(
                            text: "S'inscrire",
                            onPressed: _handleRegister,
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
import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation mot de passe robuste
  String? _validatePassword(String password) {
    if (password.length < 8) return 'Au moins 8 caractères requis';
    if (!password.contains(RegExp(r'[A-Z]')))
      return 'Au moins une lettre majuscule requise';
    if (!password.contains(RegExp(r'[a-z]')))
      return 'Au moins une lettre minuscule requise';
    if (!password.contains(RegExp(r'[0-9]'))) return 'Au moins un chiffre requis';
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      return 'Au moins un caractère spécial requis';
    return null;
  }

  Future<void> _handleReset() async {
    final username = _usernameController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final passwordError = _validatePassword(newPassword);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError), backgroundColor: Colors.red),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Appel backend pour réinitialiser le mot de passe
      // Pour l'instant on simule le succès
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mot de passe réinitialisé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la réinitialisation'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.lock_reset_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Réinitialiser le mot de passe',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entrez votre nom d\'utilisateur et votre nouveau mot de passe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textDarkSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              TextFieldWidget(
                label: "Nom d'utilisateur",
                placeholder: "Votre nom d'utilisateur",
                prefixIcon: Icons.person_outline,
                controller: _usernameController,
              ),
              const SizedBox(height: 20),

              TextFieldWidget(
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onSuffixIconPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                label: "Nouveau mot de passe",
                placeholder: "Min. 8 car., maj., chiffre, symbole",
                prefixIcon: Icons.lock_outline,
                controller: _newPasswordController,
              ),
              const SizedBox(height: 20),

              TextFieldWidget(
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onSuffixIconPressed: () => setState(
                    () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                label: "Confirmer le nouveau mot de passe",
                placeholder: "Confirmez votre mot de passe",
                prefixIcon: Icons.lock_outline,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 32),

              _isLoading
                  ? const CircularProgressIndicator()
                  : CtaButtonWidget(
                      text: "Réinitialiser",
                      onPressed: _handleReset,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
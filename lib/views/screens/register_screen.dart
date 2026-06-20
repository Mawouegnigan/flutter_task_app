import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/view/auth_header_view.dart';
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
  bool? _isUsernameAvailable;
  bool _isCheckingUsername = false;
  File? _selectedPhoto;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Vérifier la robustesse du mot de passe
  String? _validatePassword(String password) {
    if (password.length < 8) return 'Au moins 8 caractères requis';
    if (!password.contains(RegExp(r'[A-Z]')))
      return 'Au moins une lettre majuscule requise';
    if (!password.contains(RegExp(r'[a-z]')))
      return 'Au moins une lettre minuscule requise';
    if (!password.contains(RegExp(r'[0-9]')))
      return 'Au moins un chiffre requis';
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      return 'Au moins un caractère spécial requis (!@#\$%^&*...)';
    return null;
  }

  // Indicateur de robustesse du mot de passe
  double _passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score / 5;
  }

  Color _passwordStrengthColor(double strength) {
    if (strength < 0.4) return Colors.red;
    if (strength < 0.8) return Colors.orange;
    return Colors.green;
  }

  String _passwordStrengthLabel(double strength) {
    if (strength < 0.4) return 'Faible';
    if (strength < 0.8) return 'Moyen';
    return 'Fort';
  }

  // Vérifier username en temps réel
  Future<void> _checkUsername(String username) async {
    if (username.length < 3) {
      setState(() => _isUsernameAvailable = null);
      return;
    }
    setState(() => _isCheckingUsername = true);
    final available = await AuthService.isUsernameAvailable(username);
    if (mounted) {
      setState(() {
        _isUsernameAvailable = available;
        _isCheckingUsername = false;
      });
    }
  }

  // Choisir une photo
  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _selectedPhoto = File(picked.path));
    }
  }

  Future<void> _handleRegister() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (nom.isEmpty ||
        prenom.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Vérifier username disponible
    if (_isUsernameAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce nom d\'utilisateur est déjà pris'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Vérifier mot de passe robuste
    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
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
      final success = await AuthService.register(
        nom: nom,
        prenom: prenom,
        username: username,
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès !')),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final strength = _passwordStrength(password);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              AuthHeaderView(
                title: "Bienvenue parmi nous !",
                subtitle:
                    "Créez votre espace personnel pour organiser vos projets en toute simplicité.",
              ),
              const SizedBox(height: 24),

              // ── Photo de profil ──────────────────────────────
              GestureDetector(
                onTap: _pickPhoto,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor:
                          AppColors.textDarkSecondary.withAlpha(40),
                      backgroundImage: _selectedPhoto != null
                          ? FileImage(_selectedPhoto!)
                          : null,
                      child: _selectedPhoto == null
                          ? const Icon(Icons.person,
                              size: 48, color: AppColors.textDarkSecondary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Photo de profil (optionnelle)',
                style: TextStyle(
                  color: AppColors.textDarkSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),

              // ── Formulaire ───────────────────────────────────
              Form(
                child: Column(
                  children: [
                    TextFieldWidget(
                      label: "Nom",
                      placeholder: "DOE",
                      prefixIcon: Icons.person_outline,
                      controller: _nomController,
                    ),
                    const SizedBox(height: 20),

                    TextFieldWidget(
                      label: "Prénom",
                      placeholder: "John",
                      prefixIcon: Icons.person_outline,
                      controller: _prenomController,
                    ),
                    const SizedBox(height: 20),

                    // Username avec vérification
                    TextFieldWidget(
                      label: "Nom d'utilisateur",
                      placeholder: "johndoe",
                      prefixIcon: Icons.badge_outlined,
                      controller: _usernameController,
                      onChanged: (val) => _checkUsername(val),
                      suffixIcon: _isCheckingUsername
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : _isUsernameAvailable == null
                              ? null
                              : Icon(
                                  _isUsernameAvailable!
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _isUsernameAvailable!
                                      ? Colors.green
                                      : Colors.red,
                                ),
                    ),
                    if (_isUsernameAvailable == false)
                      const Padding(
                        padding: EdgeInsets.only(top: 4, left: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ce nom d\'utilisateur est déjà pris',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    if (_isUsernameAvailable == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 4, left: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nom d\'utilisateur disponible',
                            style:
                                TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    TextFieldWidget(
                      label: "Email",
                      placeholder: "john.doe@exemple.com",
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),

                    // Mot de passe avec indicateur
                    TextFieldWidget(
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onSuffixIconPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                      label: "Mot de passe",
                      placeholder: "Min. 8 car., maj., chiffre, symbole",
                      prefixIcon: Icons.lock_outline,
                      controller: _passwordController,
                      onChanged: (_) => setState(() {}),
                    ),

                    // Indicateur de robustesse
                    if (password.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: strength,
                                backgroundColor:
                                    AppColors.textDarkSecondary.withAlpha(30),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _passwordStrengthColor(strength),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _passwordStrengthLabel(strength),
                            style: TextStyle(
                              fontSize: 12,
                              color: _passwordStrengthColor(strength),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (_validatePassword(password) != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _validatePassword(password)!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                    const SizedBox(height: 20),

                    TextFieldWidget(
                      isPassword: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onSuffixIconPressed: () => setState(() =>
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible),
                      label: "Confirmer le mot de passe",
                      placeholder: "Confirmez votre mot de passe",
                      prefixIcon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 20),

                    _isLoading
                        ? const CircularProgressIndicator()
                        : CtaButtonWidget(
                            text: "S'inscrire",
                            onPressed: _handleRegister,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Déjà membre ? "),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
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
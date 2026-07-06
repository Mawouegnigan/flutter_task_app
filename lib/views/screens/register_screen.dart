import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/screens/email_verification_screen.dart';
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
        SnackBar(content: Text('register_fill_fields'.tr(context))),
      );
      return;
    }

    // Vérifier username disponible
    if (_isUsernameAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('register_username_taken'.tr(context)),
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
        SnackBar(
          content: Text('register_passwords_mismatch'.tr(context)),
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
          SnackBar(content: Text('register_success'.tr(context))),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
              username: username,
              email: email,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('register_error'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('register_error'.tr(context)),
          backgroundColor: Colors.red,
        ),
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
                title: 'register_welcome'.tr(context),
                subtitle: 'register_subtitle'.tr(context),
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
              Text(
                'register_photo_optional'.tr(context),
                style: const TextStyle(
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
                      label: 'register_last_name'.tr(context),
                      placeholder: "DOE",
                      prefixIcon: Icons.person_outline,
                      controller: _nomController,
                    ),
                    const SizedBox(height: 20),

                    TextFieldWidget(
                      label: 'register_first_name'.tr(context),
                      placeholder: "John",
                      prefixIcon: Icons.person_outline,
                      controller: _prenomController,
                    ),
                    const SizedBox(height: 20),

                    // Username avec vérification
                    TextFieldWidget(
                      label: 'register_username'.tr(context),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'register_username_taken_inline'.tr(context),
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    if (_isUsernameAvailable == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'register_username_available'.tr(context),
                            style: const TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    TextFieldWidget(
                      label: 'register_email'.tr(context),
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
                      label: 'register_password'.tr(context),
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
                      label: 'register_confirm_password'.tr(context),
                      placeholder: "Confirmez votre mot de passe",
                      prefixIcon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 20),

                    _isLoading
                        ? const CircularProgressIndicator()
                        : CtaButtonWidget(
                            text: 'register_button'.tr(context),
                            onPressed: _handleRegister,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('register_already_member'.tr(context)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'register_login_link'.tr(context),
                      style: const TextStyle(
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
import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';
import 'package:flutter_task_app/services/auth_service.dart';

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
  String? _validatePassword(String password, BuildContext context) {
    if (password.length < 8) return 'password_min_length'.tr(context);
    if (!password.contains(RegExp(r'[A-Z]')))
      return 'password_uppercase'.tr(context);
    if (!password.contains(RegExp(r'[a-z]')))
      return 'password_lowercase'.tr(context);
    if (!password.contains(RegExp(r'[0-9]'))) return 'password_digit'.tr(context);
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      return 'password_special'.tr(context);
    return null;
  }

  Future<void> _handleReset() async {
    final username = _usernameController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('forgot_fill_fields'.tr(context))),
      );
      return;
    }

    final passwordError = _validatePassword(newPassword, context);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError), backgroundColor: Colors.red),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('forgot_passwords_mismatch'.tr(context)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.resetPassword(
        username: username,
        newPassword: newPassword,
      );
      if (!success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('forgot_user_not_found'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('forgot_success'.tr(context)),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('forgot_error'.tr(context)),
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
        title: Text('forgot_title'.tr(context)),
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
              Text(
                'forgot_screen_title'.tr(context),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'forgot_screen_subtitle'.tr(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textDarkSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              TextFieldWidget(
                label: 'login_username'.tr(context),
                placeholder: 'forgot_username_placeholder'.tr(context),
                prefixIcon: Icons.person_outline,
                controller: _usernameController,
              ),
              const SizedBox(height: 20),

              TextFieldWidget(
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onSuffixIconPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                label: 'forgot_new_password'.tr(context),
                placeholder: 'register_password_placeholder'.tr(context),
                prefixIcon: Icons.lock_outline,
                controller: _newPasswordController,
              ),
              const SizedBox(height: 20),

              TextFieldWidget(
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onSuffixIconPressed: () => setState(
                    () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                label: 'forgot_confirm_password'.tr(context),
                placeholder: 'register_confirm_password_placeholder'.tr(context),
                prefixIcon: Icons.lock_outline,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 32),

              _isLoading
                  ? const CircularProgressIndicator()
                  : CtaButtonWidget(
                      text: 'forgot_reset_button'.tr(context),
                      onPressed: _handleReset,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
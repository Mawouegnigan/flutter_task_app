import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

/// Écran affiché juste après l'inscription : l'utilisateur saisit le code
/// à 6 chiffres reçu par email pour valider son compte.
/// [username] : nom d'utilisateur du compte à vérifier
/// [email] : email auquel le code a été envoyé (affiché à titre indicatif)
class EmailVerificationScreen extends StatefulWidget {
  final String username;
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _codeController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 30);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCooldown = 0);
      } else {
        if (mounted) setState(() => _resendCooldown -= 1);
      }
    });
  }

  Future<void> _handleVerify() async {
    final code = _codeController.text.trim();

    if (code.isEmpty || code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('email_verification_invalid_length'.tr(context))),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final success = await AuthService.verifyCode(
        username: widget.username,
        code: code,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('email_verification_success'.tr(context)),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('email_verification_wrong_code'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('email_verification_error'.tr(context)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _handleResend() async {
    if (_resendCooldown > 0) return;

    setState(() => _isResending = true);

    try {
      await AuthService.sendCode(username: widget.username);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('email_verification_code_resent'.tr(context))),
      );
      _startCooldown();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('email_verification_error'.tr(context)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('email_verification_title'.tr(context)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'email_verification_screen_title'.tr(context),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'email_verification_screen_subtitle'.tr(context, title: widget.email),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textDarkSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              TextFieldWidget(
                label: 'email_verification_code_label'.tr(context),
                placeholder: '123456',
                prefixIcon: Icons.pin_outlined,
                controller: _codeController,
              ),
              const SizedBox(height: 32),

              _isVerifying
                  ? const CircularProgressIndicator()
                  : CtaButtonWidget(
                      text: 'email_verification_verify_button'.tr(context),
                      onPressed: _handleVerify,
                    ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('email_verification_no_code'.tr(context)),
                  InkWell(
                    onTap: (_isResending || _resendCooldown > 0)
                        ? null
                        : _handleResend,
                    child: Text(
                      _resendCooldown > 0
                          ? 'email_verification_resend_countdown'
                              .tr(context, title: '$_resendCooldown')
                          : 'email_verification_resend'.tr(context),
                      style: TextStyle(
                        color: (_isResending || _resendCooldown > 0)
                            ? AppColors.textDarkSecondary
                            : AppColors.primary,
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

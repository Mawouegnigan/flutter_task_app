import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class TextFieldWidget extends StatelessWidget {
  final String label, placeholder;
  final IconData prefixIcon;
  final bool isPassword, isPasswordVisible;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.placeholder,
    required this.prefixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onSuffixIconPressed,
    this.controller,
    this.validator,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(isPassword ? Icons.lock_outline : prefixIcon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onSuffixIconPressed,
              )
            : suffixIcon,
        label: Text(label),
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: AppColors.textDarkSecondary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.textDarkSecondary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
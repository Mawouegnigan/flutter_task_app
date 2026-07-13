import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

/// Un widget réutilisable du boutton d'appel à l'action (CTA) 
class CtaButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CtaButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

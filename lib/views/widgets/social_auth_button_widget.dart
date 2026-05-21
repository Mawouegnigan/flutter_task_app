import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/utils/constants.dart';

class SocialAuthButtonWidget extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onPressed;

  const SocialAuthButtonWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          iconAlignment: IconAlignment.start,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: const BorderSide(color: AppColors.textDarkSecondary, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: SvgPicture.asset(icon, width: 24, height: 24),
          onPressed: onPressed,
          label: Text(
            label, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, 
              // fontWeight: FontWeight.w300, 
              color: AppColors.textDarkPrimary,
            )
          ),
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class PriorityItemWidget extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected, isAddButton;
  final VoidCallback? onTap;

  const PriorityItemWidget({
    super.key,
    required this.label,
    required this.color,
    this.isSelected = false,
    this.isAddButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        // Si le composant est cliquable et non sélectionné, on baisse légèrement l'opacité
        opacity: isSelected ? 1.0 : 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Le cercle de couleur
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isAddButton ? null : color,
                gradient: isAddButton 
                  ? SweepGradient(
                    // center: Alignment.center,
                    // radius: 0.5,
                    colors: [
                      AppColors.priorityLow,
                      AppColors.priorityMedium,
                      AppColors.priorityHigh
                    ],
                  )
                : null,
                shape: BoxShape.circle,
                // Optionnel : petite bordure si sélectionné
                border: isSelected 
                    ? Border.all(color: Colors.black, width: 2) 
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            // Le label en dessous
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

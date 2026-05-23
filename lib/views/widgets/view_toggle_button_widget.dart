import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class ViewToggleButtonWidget extends StatelessWidget {
  final bool isGrid;
  final VoidCallback onTap;
 
  const ViewToggleButtonWidget({
    super.key,
    required this.isGrid, 
    required this.onTap
  });
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
 
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(50), width: 1.5)
        ),
        child: Icon(
          isGrid ? Icons.view_agenda_rounded : Icons.grid_view_rounded, 
          size: 22, 
          color: AppColors.textDarkSecondary
        ),
      ),
    );
  }
}

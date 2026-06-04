import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class SortOrderToggleButtonWidget extends StatefulWidget {
  final ValueChanged<bool>? onToggle;

  const SortOrderToggleButtonWidget({super.key, this.onToggle});

  @override
  State<SortOrderToggleButtonWidget> createState() => _SortOrderToggleButtonWidgetState();
}

class _SortOrderToggleButtonWidgetState extends State<SortOrderToggleButtonWidget> {
  bool triActif = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: triActif
              ? AppColors.primary
              : Theme.of(context).colorScheme.outlineVariant.withAlpha(50),
          width: 1.5,
        ),
        color: triActif
            ? AppColors.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IconButton(
        icon: Icon(
          Icons.swap_vert,
          size: 28,
          color: triActif
              ? Colors.white
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        tooltip: triActif
            ? 'Désactiver le tri par date'
            : 'Trier par date d\'échéance',
        onPressed: () {
          setState(() {
            triActif = !triActif;
          });
          widget.onToggle?.call(triActif);
        },
      ),
    );
  }
}
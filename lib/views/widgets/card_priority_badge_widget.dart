import 'package:flutter/material.dart';

class CardPriorityBadgeWidget extends StatelessWidget {
  final String priority;
  final Color color;
  const CardPriorityBadgeWidget({
    super.key, 
    required this.priority, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
      ), 
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
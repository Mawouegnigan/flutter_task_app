import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_api_model.dart';
import 'package:flutter_task_app/services/share_service.dart';
import 'package:flutter_task_app/utils/constants.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskApiModel task;
  const TaskDetailScreen({super.key, required this.task});


  String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return 'Haute';
      case 'medium': return 'Moyenne';
      case 'low': return 'Basse';
      default: return priority;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(task.priority);
    final isCompleted = task.color == '#9E9E9E';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la tâche"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Partager',
            icon: const Icon(Icons.share_rounded),
            onPressed: () => ShareService.shareTask(task),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _priorityLabel(task.priority),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            if (task.content.isNotEmpty) ...[
              Text(
                task.content,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textDarkSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Date d'échéance
            if (task.dueDate != null)
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year} "
                    "à ${task.dueDate!.hour.toString().padLeft(2, '0')}h"
                    "${task.dueDate!.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            const SizedBox(height: 12),

            // Statut
            Row(
              children: [
                Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  size: 18,
                  color: isCompleted ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  isCompleted ? "Terminée" : "En cours",
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted ? AppColors.primary : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Date de création
            if (task.createdAt != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Créée le ${task.createdAt!.day}/${task.createdAt!.month}/${task.createdAt!.year}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
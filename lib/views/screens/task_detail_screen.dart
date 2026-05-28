import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/utils/constants.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la tâche"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            if (task.description != null) ...[
              Text(
                task.description!,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textDarkSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Date d'échéance
            if (task.deadline != null)
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    task.deadline!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            const SizedBox(height: 12),

            // Priorité
            if (task.priority != null)
              Row(
                children: [
                  const Icon(Icons.flag_rounded, size: 18),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.priority!.color.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.priority!.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: task.priority!.color,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),

            // Statut
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 18),
                const SizedBox(width: 8),
                Text(
                  task.status == TaskStatus.done ? "Terminée" : "En cours",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
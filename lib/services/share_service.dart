import 'package:share_plus/share_plus.dart';
import '../models/task_api_model.dart';

class ShareService {
  static Future<void> shareTask(TaskApiModel task) async {
    final priority = _priorityLabel(task.priority);
    final isCompleted = task.color == '#9E9E9E';
    final status = isCompleted ? 'Terminée' : 'En cours';
    final deadline = task.dueDate != null
        ? '${task.dueDate!.day.toString().padLeft(2, '0')}/'
          '${task.dueDate!.month.toString().padLeft(2, '0')}/'
          '${task.dueDate!.year}'
        : 'Aucune échéance';

    final text = '📋 Tâche : ${task.title}\n\n'
        '📝 Description : ${task.content.isNotEmpty ? task.content : 'Aucune description'}\n'
        '🎯 Priorité : $priority\n'
        '📅 Échéance : $deadline\n'
        '✅ Statut : $status\n\n'
        'Partagé via TaskFlow';

    await Share.shareXFiles([], text: text);
  }

  static String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'Haute';
      case 'medium':
        return 'Moyenne';
      case 'low':
        return 'Basse';
      default:
        return priority;
    }
  }
}
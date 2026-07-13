import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/utils/constants.dart';

class TaskMockData {
  static List<TaskModel> tasks = [
    TaskModel(
      id: '1',
      title: 'Créer UI Flutter',
      description: 'Construire les cards modernes',
      deadline: "27/05/2026",
      priority: const TaskPriorityModel(
        label: 'Low',
        color: AppColors.priorityLow,
      ),
    ),
    TaskModel(
      id: '2',
      title: 'Étudier architecture',
      description: "Reuissir le BAC",
      priority: const TaskPriorityModel(
        label: 'Medium',
        color: AppColors.priorityMedium,
      ),
    ),
    TaskModel(
      id: '3',
      title: 'Avoir un V0 pret et livrable en 3jrs',
      description: "5 pages de l'app en 3jrs :)",
      priority: const TaskPriorityModel(
        label: 'High',
        color: AppColors.priorityHigh,
      ),
    ),
  ];
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/task_model.dart';

class TaskNotifier extends Notifier<List<TaskModel>> {
  @override
  List<TaskModel> build() {
    // Tu peux retourner une liste vide par défaut ou des tâches initiales de test
    return [];
  }

  // Action pour AJOUTER une tâche
  void addTask(TaskModel task) {
    state = [...state, task];
  }

  // Action pour MODIFIER une tâche existante
  void updateTask(TaskModel updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task
    ];
  }

  // Action pour SUPPRIMER une tâche
  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  // Action pour basculer le statut d'une tâche
  // void toggleTaskStatus(String id) {
  //   state = [
  //     for (final task in state)
  //       if (task.id == id)
  //         TaskModel(
  //           id: task.id,
  //           title: task.title,
  //           description: task.description,
  //           deadline: task.deadline,
  //           priority: task.priority,
  //           selected: task.selected,
  //           status: task.status == TaskStatus.pending 
  //               ? TaskStatus.done 
  //               : TaskStatus.pending,
  //         )
  //       else
  //         task
  //   ];
  // }
}

// Le provider global pour accéder à la liste des tâches partout dans l'app
final taskProvider = NotifierProvider<TaskNotifier, List<TaskModel>>(
  TaskNotifier.new,
);
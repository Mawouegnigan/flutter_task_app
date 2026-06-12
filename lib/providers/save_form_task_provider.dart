// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_task_app/models/filter_model.dart';
// import 'package:flutter_task_app/models/task_model.dart';
// import 'package:flutter_task_app/providers/filter_provider.dart';

// class TaskFormState {
//   final String title;
//   final String description;
//   final bool showDescription;
//   final DateTime? deadline;
//   final TimeOfDay? reminder;
//   final String priority;
//   final FilterModel label;

//   const TaskFormState({
//     this.title = '',
//     this.description = '',
//     this.deadline = null,
//     this.reminder = null,
//     this.priority = 'Moyenne',
//     FilterModel? label,
//   }) : label = label ?? noneFilter;

//   bool get isValid => title.trim().isNotEmpty;

//   TaskFormState copyWith({
//     String? title,
//     String? description,
//     DateTime? deadline,
//     TimeOfDay? reminder,
//     String? priority,
//     FilterModel? label,
//   }) {
//     return TaskFormState(
//       title: title ?? this.title,
//       description: description ?? this.description,
//       deadline: deadline ?? this.deadline,
//       reminder: reminder ?? this.reminder,
//       priority: priority ?? this.priority,
//       label: label ?? this.label,
//     );
//   }
// }

// class TaskFormNotifier extends Notifier<TaskFormState> {
//   @override
//   TaskFormState build() => const TaskFormState();

//   void setTitle(String value) =>
//       state = state.copyWith(title: value);

//   void setDescription(String value) =>
//       state = state.copyWith(description: value);


//   void setDeadline(DateTime? date) =>
//       state = state.copyWith(deadline: date);

//   void setReminder(TimeOfDay? time) =>
//       state = state.copyWith(reminder: time);

//   void setPriority(String priority) =>
//       state = state.copyWith(priority: priority);

//   void setLabel(FilterModel label) =>
//       state = state.copyWith(label: label);

//   void reset() => state = const TaskFormState();

//   // Construit le TaskModel final à sauvegarder
//   TaskModel submit() {
//     return TaskModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: state.title.trim(),
//       description: state.description.trim().isEmpty
//           ? null
//           : state.description.trim(),
//       deadline: state.deadline != null
//           ? '${state.deadline!.day}/${state.deadline!.month}/${state.deadline!.year}'
//           : null,
//       priority: _buildPriority(state.priority),
//     );
//   }

//   TaskPriorityModel? _buildPriority(String priority) {
//     switch (priority) {
//       case 'Basse':
//         return TaskPriorityModel(
//             label: 'Basse', color: AppColors.priorityLow);
//       case 'Haute':
//         return TaskPriorityModel(
//             label: 'Haute', color: AppColors.priorityHigh);
//       default:
//         return TaskPriorityModel(
//             label: 'Moyenne', color: AppColors.priorityMedium);
//     }
//   }
// }

// final taskFormProvider =
//     NotifierProvider<TaskFormNotifier, TaskFormState>(
//   TaskFormNotifier.new,
// );
import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/filter_model.dart';

enum TaskStatus { pending, done }
enum RepeatOption {
  none('Pas de répétition'),
  daily('Chaque jour'),
  weekly('Chaque semaine'),
  monthly('Chaque mois'),
  yearly('Chaque année');
 
  final String label;
  const RepeatOption(this.label);
}


class TaskModel {
  final String id, title, description;
  // final String? deadline;
  final DateTime? deadline; 
  final TimeOfDay? reminderTime;
  final TaskPriorityModel? priority;
  final TaskStatus status;
  final bool selected;
  final FilterModel? category;
  final RepeatOption repeat;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.reminderTime,
    this.status = TaskStatus.pending,
    this.selected = false,
    this.priority,
    this.category,
    this.repeat = RepeatOption.none
  });
}

class TaskPriorityModel {
  final String label;
  final Color color;

  const TaskPriorityModel({
    required this.label,
    required this.color,
  });
}
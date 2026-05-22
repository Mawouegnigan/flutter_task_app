import 'package:flutter/material.dart';

enum TaskStatus { pending, done }

class TaskModel {
  final String id, title;
  final String? description, deadline;
  final TaskPriorityModel? priority;
  final TaskStatus status;
  final bool selected;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.status = TaskStatus.pending,
    this.selected = false,
    this.priority,
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
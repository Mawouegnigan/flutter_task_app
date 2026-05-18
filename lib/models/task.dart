import 'package:flutter/material.dart';

class Task {
  final String title;
  final String content;
  final DateTime dateTime;
  final String priority;
  final Color priorityColor;

  Task({
    required this.title,
    required this.content,
    required this.dateTime,
    required this.priority,
    required this.priorityColor,
  });
}
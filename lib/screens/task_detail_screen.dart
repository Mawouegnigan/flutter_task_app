import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la tâche"),
      ),
      body: const Center(
        child: Text("Task Detail Screen"),
      ),
    );
  }
}
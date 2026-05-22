import 'package:flutter/material.dart';

class AddEditingTaskScreen extends StatefulWidget {
  final String mode;
  const AddEditingTaskScreen({ super.key, required this.mode });

  @override
  State<AddEditingTaskScreen> createState() => _AddEditingTaskScreenState();
}

class _AddEditingTaskScreenState extends State<AddEditingTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == "Add" ? "Ajouter une tâche" : "Modifier une tâche"),
        centerTitle: true,

        // Les boutons d'action de l'appbar: calendrier et notifications
        actions: [
          IconButton(
            onPressed: () {}, // action à definir pour le click sur le boutton du calendrier
            icon: Icon(Icons.calendar_today_rounded),
            padding: const EdgeInsets.all(12),
            iconSize: 22,
          ),

          // A faire: ajouter un badge de notification sur le boutton lorsqu'il y a des notification non lues
          IconButton(
            onPressed: () {}, // action à definir pour le click sur le boutton des notifications
            icon: Icon(Icons.notifications_outlined),
            padding: const EdgeInsets.all(10),
            iconSize: 28,
          ),
        ]
      ),
    );
  }
}
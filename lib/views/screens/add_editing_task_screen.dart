import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/priority_item_widget.dart';

class AddEditingTaskScreen extends StatefulWidget {
  final String mode;
  const AddEditingTaskScreen({super.key, required this.mode});

  @override
  State<AddEditingTaskScreen> createState() => _AddEditingTaskScreenState();
}

class _AddEditingTaskScreenState extends State<AddEditingTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title: Text(widget.mode == "Add"
              ? "Ajouter une tâche"
              : "Modifier une tâche"),
          centerTitle: true,

          // Les boutons d'action de l'appbar: calendrier et notifications
          actions: [
            IconButton(
              onPressed:
                  () {}, // action à definir pour le click sur le boutton de l'horloge
              icon: Icon(Icons.alarm),
              padding: const EdgeInsets.all(12),
              iconSize: 22,
            ),

            // A faire: ajouter un badge de notification sur le boutton lorsqu'il y a des notification non lues
            IconButton(
              onPressed:
                  () {}, // action à definir pour le click sur le boutton des notifications
              icon: Icon(Icons.notifications_outlined),
              padding: const EdgeInsets.all(10),
              iconSize: 28,
            ),
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(label: "Titre", hintText: "Saissisez votre titre"),
            SizedBox(height: 20),
            CustomInputField(
              label: "Description de la tâche ",
              hintText: "Décrivez votre tâche...",
              isTextArea: true,
            ),
            SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Priorité",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Row(spacing: 20, children: [
                PriorityItemWidget(
                  label: "Low",
                  color: AppColors.priorityLow,
                ),
                PriorityItemWidget(
                  label: "Medium",
                  color: AppColors.priorityMedium,
                ),
                PriorityItemWidget(
                  label: "High",
                  color: AppColors.priorityHigh,
                ),
                PriorityItemWidget(
                  label: "Add",
                  color: Colors.transparent,
                  isAddButton: true,
                ),
              ]),
              SizedBox(height: 20),
              CtaButtonWidget(
                text: "Enregistrer",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              )
            ])
          ],
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isTextArea;
  // final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.isTextArea = false,
    // this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label du champ de saisie
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Le champ de saisie configurable
        TextField(
          // controller: controller,
          keyboardType:
              isTextArea ? TextInputType.multiline : TextInputType.text,
          maxLines: isTextArea ? null : 1,
          minLines: isTextArea ? 5 : 1,

          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            hintStyle: TextStyle(
              color: AppColors.textDarkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

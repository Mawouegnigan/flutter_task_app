import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_api_model.dart';
import 'package:flutter_task_app/services/task_service.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/services/notification_service.dart';
import 'package:flutter_task_app/views/screens/calendar_screen.dart';
import 'package:flutter_task_app/views/screens/notifications_settings_screen.dart';

const List<String> kCategories = [
  'Travail',
  'Personnel',
  'Études',
  'Santé',
  'Courses',
  'Autre',
];

class AddEditingTaskScreen extends StatefulWidget {
  final String mode;
  final TaskApiModel? task;

  const AddEditingTaskScreen({
    super.key,
    required this.mode,
    this.task,
  });

  @override
  State<AddEditingTaskScreen> createState() => _AddEditingTaskScreenState();
}

class _AddEditingTaskScreenState extends State<AddEditingTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime? _selectedDeadline;
  String _selectedPriority = 'Low';
  String _selectedColor = '#4CAF50';
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'Edit' && widget.task != null) {
      _titleController.text = widget.task!.title;
      _contentController.text = widget.task!.content;
      _selectedPriority = widget.task!.priority;
      _selectedColor = widget.task!.color;
      _selectedDeadline = widget.task!.dueDate;
      _selectedCategory = widget.task!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDeadline != null
          ? TimeOfDay(
              hour: _selectedDeadline!.hour,
              minute: _selectedDeadline!.minute)
          : TimeOfDay.now(),
    );

    setState(() {
      if (pickedTime != null) {
        _selectedDeadline = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      } else {
        _selectedDeadline = pickedDate;
      }
    });
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez remplir le titre et la description')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final task = TaskApiModel(
        title: title,
        content: content,
        priority: _selectedPriority,
        color: _selectedColor,
        dueDate: _selectedDeadline,
        category: _selectedCategory,
      );

      if (widget.mode == 'Add') {
        final createdTask = await TaskService.createTask(task);
        try {
          await NotificationService.scheduleTaskNotification(createdTask);
        } catch (_) {}
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tâche créée avec succès !')),
        );
      } else {
        final updatedTask =
            await TaskService.updateTask(widget.task!.id!, task);
        try {
          await NotificationService.cancelTaskNotification(widget.task!.id!);
          await NotificationService.scheduleTaskNotification(updatedTask);
        } catch (_) {}
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tâche modifiée avec succès !')),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'enregistrement')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDeadline(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à ${hour}h$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.mode == "Add"
            ? "Ajouter une tâche"
            : "Modifier une tâche"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
            icon: const Icon(Icons.calendar_today_rounded),
            padding: const EdgeInsets.all(12),
            iconSize: 22,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationsSettingsScreen()),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
            padding: const EdgeInsets.all(10),
            iconSize: 28,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ titre
            CustomInputField(
              label: "Titre",
              hintText: "Saisissez votre titre",
              controller: _titleController,
            ),
            const SizedBox(height: 20),

            // Champ description
            CustomInputField(
              label: "Description de la tâche",
              hintText: "Décrivez votre tâche...",
              isTextArea: true,
              controller: _contentController,
            ),
            const SizedBox(height: 20),

            // Catégorie
            const Text(
              "Catégorie",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: kCategories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedCategory = isSelected ? null : cat;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withAlpha(30)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Date et heure d'échéance
            const Text(
              "Date et heure d'échéance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDeadline,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 18, color: AppColors.textDarkSecondary),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDeadline != null
                          ? _formatDeadline(_selectedDeadline!)
                          : "Sélectionner une date et une heure",
                      style: TextStyle(
                        color: _selectedDeadline != null
                            ? Colors.black
                            : AppColors.textDarkSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Priorité
            const Text(
              "Priorité",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Low', 'Medium', 'High'].map((priority) {
                final isSelected = _selectedPriority == priority;
                Color color = priority == 'Low'
                    ? AppColors.priorityLow
                    : priority == 'Medium'
                        ? AppColors.priorityMedium
                        : AppColors.priorityHigh;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedPriority = priority;
                      _selectedColor = priority == 'Low'
                          ? '#4CAF50'
                          : priority == 'Medium'
                              ? '#FF9800'
                              : '#F44336';
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withAlpha(40)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        priority == 'Low'
                            ? 'Basse'
                            : priority == 'Medium'
                                ? 'Moyenne'
                                : 'Haute',
                        style: TextStyle(
                          color: isSelected ? color : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Bouton enregistrer
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CtaButtonWidget(
                    text: "Enregistrer",
                    onPressed: _handleSave,
                  ),
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
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.isTextArea = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
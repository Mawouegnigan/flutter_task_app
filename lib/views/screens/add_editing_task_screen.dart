import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/filter_model.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/providers/filter_provider.dart';
import 'package:flutter_task_app/providers/repeat_datetime_task_provider.dart';
import 'package:flutter_task_app/providers/task_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/add_label_to_task.dart';
import 'package:flutter_task_app/views/view/repeat_bottom_sheet.dart';
import 'package:flutter_task_app/views/widgets/show_snackbar_widget.dart';


class AddEditingTaskScreen extends ConsumerStatefulWidget {
  final String mode;
  final TaskModel? taskToEdit;

  const AddEditingTaskScreen({super.key, required this.mode, this.taskToEdit});

  @override
  ConsumerState<AddEditingTaskScreen> createState() => _AddEditingTaskScreenState();
}

class _AddEditingTaskScreenState extends ConsumerState<AddEditingTaskScreen> {
  FilterModel? _selectedLabel = noneFilter ;
  String _selectedPriority = 'Moyenne';

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Fonction Asynchrone pour la selection de Date de l'echeance des taches
  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fonction Asynchrone pour la selection de l'Heure de rapel des tache
  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 10),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Ouvre le bottom sheet pour la selection de la repetition des taches et retourne la valeur choisie.
  Future<void> showRepeatBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RepeatBottomSheet(),
    );
  }

  @override
  void initState() {
    super.initState();
    // Si on est en mode édition, on pré-remplit les champs avec la tâche existante
    if (widget.mode == "Edit" && widget.taskToEdit != null) {
      final task = widget.taskToEdit!;
      _titleController.text = task.title;
      _descController.text = task.description;
      _selectedPriority = task.priority?.label ?? 'Moyenne';

      if (task.deadline != null) {
        _selectedDate = task.deadline;
      }
      
      if (task.reminderTime != null) {
        _selectedTime = task.reminderTime;
      }
      _selectedLabel = task.category ?? noneFilter;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(repeatProvider.notifier).select(task.repeat);
      });

    }
  }

  TaskPriorityModel getPriorityModel(String priorityLabel) {
    switch (priorityLabel) {
      case 'Basse':
        return const TaskPriorityModel(label: 'Basse', color: AppColors.priorityLow);
      case 'Haute':
        return const TaskPriorityModel(label: 'Haute', color: AppColors.priorityHigh);
      case 'Moyenne':
      default:
        return const TaskPriorityModel(label: 'Moyenne', color: AppColors.priorityMedium);
    }
  }

  void saveTask() {
    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ShowSnackbarWidget.show(
        context: context,
        message: "Titre & description sont obligatoires",
        icon: Icons.close,
        color: AppColors.priorityHigh,
      );
      return;
    }

    // Recuperation de l'option de repetition
    final selectedRepeat = ref.read(repeatProvider);

    debugPrint(description);

    // Creation de nouveau task si en mode Edit
    if(widget.mode == "Add") {
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unique temporaire
        title: title,
        description: description,
        deadline: _selectedDate,
        reminderTime: _selectedTime,
        priority: getPriorityModel(_selectedPriority),
        category: (_selectedLabel?.id == 'none') ? null : _selectedLabel,
        repeat: selectedRepeat,   
      );

      ref.read(taskProvider.notifier).addTask(newTask);

      debugPrint("""
        ====== Tâche créée : ======
        ID: ${newTask.id}
        Titre: ${newTask.title}, 
        Priorité: ${newTask.priority?.label},
        Deadline: ${newTask.deadline} 
        Répétition: ${selectedRepeat.name}, 
        Catégorie: ${_selectedLabel?.id}
      """);

      debugPrint("${ref.watch(taskProvider)}");

      // Ajouter la task a la BD
      // Afficher un SnackBar de validation

    } else if(widget.mode == "Edit" && widget.taskToEdit != null) {
      // Modification de la tache 
      final updatedTask = TaskModel(
        id: widget.taskToEdit!.id,
        title: title,
        description: description,
        deadline: _selectedDate, 
        reminderTime: _selectedTime,
        priority: getPriorityModel(_selectedPriority),
        status: widget.taskToEdit!.status,
        category: (_selectedLabel?.id == 'none') ? null : _selectedLabel, // ← catégorie
        repeat: selectedRepeat,
      );

      ref.read(taskProvider.notifier).updateTask(updatedTask);

      debugPrint('Tâche modifiée : ${updatedTask.title}');

      // Ajouter la task a la BD
      // Afficher un SnackBar de validation
    }

    // Reinitialiser le provider de repetition à sa valeur par eéfaut apres l'enregistrement
    ref.read(repeatProvider.notifier).select(RepeatOption.none);

    if(widget.mode == "Add") {
      ShowSnackbarWidget.show(
        context: context,
        message: "La tâche a été ajoutée avec succès.",
        icon: Icons.check,
        color: AppColors.priorityLow,
      );
    }else if(widget.mode == "Edit" && widget.taskToEdit != null) {
      ShowSnackbarWidget.show(
        context: context,
        message: "La tâche a été modifiée avec succès.",
        icon: Icons.check,
        color: AppColors.priorityLow,
      );
    }
    
    // Naviger vers la homePage avec les task qui est a jour
    Navigator.pop(context);
  }

  

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final selectedRepeat = ref.watch(repeatProvider); 

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
        // centerTitle: true,
        // Les boutons d'action de l'appbar: calendrier et notifications
        actions: [
          TextButton(
            onPressed: () => saveTask(), 
            style: TextButton.styleFrom(
              overlayColor: Colors.transparent
            ),
            child: Text("SAUVEGARDER"),
          )
        ]
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: Titre et Description ---
            _buildSection(
              icon: Icons.check_circle_outline,
              content: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Titre", 
                      hintStyle: TextStyle(fontSize: 24, color: AppColors.textDarkSecondary),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24,),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _descController,
                          onChanged: (value) {setState(() {});},
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Ajouter une description...",
                            hintStyle: TextStyle(color: AppColors.textDarkSecondary),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      _descController.text.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              _descController.clear();
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(Icons.close, size: 18),
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                    ],
                  ),                
                ],
              ),
            ),
            Divider(color: AppColors.textDarkSecondary, indent: 16, endIndent: 16),

            // --- SECTION 2: Date de Rappel ---
            ListTile(
              onTap: () => selectDate(),
              leading: Icon(Icons.access_time, color: Colors.grey.shade500, size: 24),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                _selectedDate != null 
                  ? "${_selectedDate!.year}. ${_selectedDate!.month}. ${_selectedDate!.day}." 
                  : "Aucune",
              )
            ),
            Divider(color: AppColors.textDarkSecondary, indent: 16, endIndent: 16),

            // --- SECTION 3: Heure de Rappel ---
            ListTile(
              onTap: () => selectTime(),
              leading: Icon(Icons.notifications_none, color: Colors.grey.shade500, size: 24),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                _selectedTime != null 
                  ? _selectedTime!.format(context) 
                  : "Ajouter un rappel",
              )
            ),
            Divider(color: AppColors.textDarkSecondary, indent: 16, endIndent: 16),

            // --- SECTION 4: Répétition ---
            ListTile(
              onTap: () => showRepeatBottomSheet(),
              leading: Icon(Icons.sync, color: Colors.grey.shade500, size: 24),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text(selectedRepeat.label)
            ),
            Divider(color: AppColors.textDarkSecondary, indent: 16, endIndent: 16),

            ListTile(
              onTap: () async {
                final result = await Navigator.push<FilterModel?>(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                      AddLabelToTask(currentCategory: _selectedLabel),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );

                if (result != null) {
                  setState(() => _selectedLabel = result);
                }
              },
              leading: Icon(Icons.label_outline, color: Colors.grey.shade500, size: 24),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text(_selectedLabel!.label)
            ),
            Divider(color: AppColors.textDarkSecondary, indent: 16, endIndent: 16),

            // --- SECTION 5: Priorité ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Icon(Icons.flag_outlined, color: Colors.grey.shade500, size: 24),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Priorité', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            segments: [
                              ButtonSegment(value: 'Basse', label: Text('Basse')),
                              ButtonSegment(value: 'Moyenne', label: Text('Moyenne')),
                              ButtonSegment(value: 'Haute', label: Text('Haute')),
                            ],
                            selected: {_selectedPriority},
                            showSelectedIcon: false,
                            onSelectionChanged: (Set<String> selection) {
                              setState(() => _selectedPriority = selection.first);
                            },
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 20.0), // Ajustez les valeurs ici
                              ),
                              backgroundColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  switch (_selectedPriority) {
                                    case 'Basse':   return AppColors.priorityLow;
                                    case 'Moyenne': return AppColors.priorityMedium;
                                    case 'Haute':   return AppColors.priorityHigh;
                                  }
                                }
                                return Colors.transparent;
                              }),
                              foregroundColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) return Colors.white;
                                return Colors.grey.shade600;
                              }),
                              side: WidgetStateProperty.all(
                                BorderSide(color: Colors.grey.shade300, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget pour build les sections icon + un autre widget ---
  Widget _buildSection({required IconData icon, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Icon(icon, color: Colors.grey.shade500, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: content),
        ],
      ),
    );
  }

//   Widget xxx() {
//     int? valeurSelected = 0;

//     return DraggableScrollableSheet(
//       initialChildSize: 0.3, 
//       minChildSize: 0.15,    
//       maxChildSize: 0.9,     
//       builder: (BuildContext context, ScrollController scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: RadioGroup<int>(
//             groupValue: valeurSelected,
//             onChanged: (int? value) {
//               setState(() {
//                 valeurSelected = value;
//               });
//             },
//             // Le child contient la structure de votre liste
//             child: ListView.builder(
//               controller: scrollController, // Si utilisé dans le DraggableScrollableSheet
//               itemCount: 20,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   leading: const Icon(Icons.star),
//                   title: Text('Option $index'),
//                   // Le Radio moderne n'a besoin QUE de sa propre valeur unique
//                   trailing: Radio<int>(
//                     value: index,
//                   ),
//                   // Permet toujours de cocher la ligne entière au clic
//                   onTap: () {
//                     setState(() {
//                       valeurSelected = index;
//                     });
//                   },
//                 );
//               },
//             ),
//           )
//         );
//       },
//     );
//   }
}


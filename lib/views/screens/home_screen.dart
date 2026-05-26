import 'package:flutter/material.dart';
import 'package:flutter_task_app/data/task_mock_data.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/add_editing_task_screen.dart';
import 'package:flutter_task_app/views/view/task_list_card_view.dart';
import 'package:flutter_task_app/views/widgets/filter_chip_button_widget.dart';
import 'package:flutter_task_app/views/widgets/view_toggle_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tasks = TaskMockData.tasks;

    return Scaffold(
      appBar: AppBar(
          // Avatar de l'utilisateur qui conduit à la page de profile au tap
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
                onTap: () {}, // action à definir pour le tap sur l'avatar
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.white, size: 20))),
          ),
          title: const Text("Mes tâches"),
          centerTitle: true,

          // Les boutons d'action de l'appbar: calendrier et notifications
          actions: [
            IconButton(
              onPressed:
                  () {}, // action à definir pour le click sur le boutton du calendrier
              icon: Icon(Icons.calendar_today_rounded),
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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

          /// SECTION DE RECHERCHE ET DE TOGGLE DE VUE
          /// A faire: connecter le TextField à une logique de recherche pour filtrer les tâches en temps réel
          ///    - Boutton de suppression (suffixIcon) pour effacer le champ de recherche
          ///    - Boutton de view grid et list pour basculer entre les deux vues de la liste des tâches
          child: Row(
            children: [
              // Champs de recherche pr filtrer les taches
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Rechercher une tâche, un projet...",
                      hintStyle: TextStyle(
                          color: AppColors.textDarkSecondary, fontSize: 14),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed:
                            () {}, // action à definir pour le tap sur le boutton de suppression du champ de recherche
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: colorScheme.outlineVariant.withAlpha(50),
                            width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: colorScheme.outlineVariant.withAlpha(50),
                            width: 1.5),
                      ),
                      filled: true),
                ),
              ),
              const SizedBox(width: 8),

              // Boutton toggle pour basculer en vue grid et list
              ViewToggleButtonWidget(
                  isGrid: true,
                  onTap:
                      () {} // Action à definir pour le tap sur le bouton de toggle
                  )
            ],
          ),
        ),

        /// SECTION DE FILTERS
        /// A faire: connecter la liste des FilterChipModel à une logique de gestion d'état pour mettre à jour la sélection des filtres
        ///   - filtrer les tâches en conséquence
        ///   - Boutton d'ajout de filtre pour permettre à l'utilisateur de créer des filtres personnalisés
        SizedBox(
          height: 40,

          // Liste horizontale de filtres pour filtrer les tâches. Chaque filtre est représenté par un FilterChipButtonWidget
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                ...[
                  TaskModel(
                      id: 'all', title: 'Toutes les tâches', selected: true),
                  TaskModel(id: 'pending', title: 'En cours', selected: false),
                  TaskModel(id: 'done', title: 'Terminées', selected: false)
                ].map(
                  (f) => Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FilterChipButtonWidget(
                        label: f.title,
                        isSelected: f.selected,
                        onTap: () {},
                      ),
                    ),
                  ),
                ),

                // Boutton d'ajout de filtre pour permettre à l'utilisateur de créer des filtres personnalisés
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 18,
                      // color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              ]),
        ),
        SizedBox(height: 10),

        /// SECTION AFFICHAGE DES LISTES DE TACHES
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskListCardView(task: task);
                }),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditingTaskScreen(
                mode: 'Add',
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

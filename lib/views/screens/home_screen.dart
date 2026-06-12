import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_task_app/providers/filter_provider.dart';
import 'package:flutter_task_app/providers/search_query_provider.dart';
import 'package:flutter_task_app/providers/task_provider.dart';
import 'package:flutter_task_app/providers/task_selection_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/add_editing_task_screen.dart';
import 'package:flutter_task_app/views/screens/profile_screen.dart';
import 'package:flutter_task_app/views/view/bottom_sheet_add_filter_view.dart';
import 'package:flutter_task_app/views/view/task_list_card_view.dart';
import 'package:flutter_task_app/views/widgets/bottom_navigation_bar_action_button_widget.dart';
import 'package:flutter_task_app/views/widgets/filter_chip_button_widget.dart';
import 'package:flutter_task_app/views/widgets/sort_order_toggle_button_widget.dart';

class HomeScreen extends ConsumerStatefulWidget  {
  const HomeScreen({ super.key });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> { 
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final tasks = TaskMockData.tasks;
    final tasks = ref.watch(taskProvider);

    final searchQuery = ref.watch(searchQueryProvider);
    final filters = ref.watch(filterProvider);

    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final selectedCount  = ref.watch(selectedCountProvider);
    final isAllSelected  = ref.watch(isAllSelectedProvider(tasks.length));

    // Méthode pour ouvrir le bottom sheet
    void openAddFilterSheet() {
      searchFocusNode.unfocus();
      showModalBottomSheet(
        
        context: context,
        isScrollControlled: true,   // important pour que le clavier ne cache pas le contenu
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => BottomSheetAddFilterView(
          onFilterAdded: (newFilter) {
            ref.read(filterProvider.notifier).add(newFilter);
          },
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        searchFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: double.infinity,
            // Avatar + nomde l'utilisateur et Date au tap qui conduisent à la page de profile
            leading: !isSelectionMode
              ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child:
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: colorScheme.primaryContainer,
                            backgroundImage: null, // ← photo plus tard
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: colorScheme.onPrimaryContainer,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDarkPrimary,
                                ),
                              ),
                              Text(
                                'Aujourd\'hui, 12 Oct',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textDarkSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              ) 
              : null,
            title: isSelectionMode 
              ? Text(
                "$selectedCount sélectionnée${selectedCount > 1 ? 's' : ''}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.textDarkPrimary),
              )
              : null,
      
            centerTitle: isSelectionMode ? false : true,
      
            // Les boutons d'action de l'appbar: calendrier et notifications si on n'es pas en mode selection, sinon boutton de selection de tous les taches
            actions: [
              !isSelectionMode 
                ? IconButton(
                  onPressed:
                      () {}, // action à definir pour le click sur le boutton du calendrier
                  icon: Icon(Icons.calendar_today_rounded),
                  padding: const EdgeInsets.all(12),
                  iconSize: 22,
                )
                : Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isAllSelected, 
                    onChanged: (value) {
                      if (isAllSelected) {
                        ref.read(taskSelectionProvider.notifier).clearAll();
                      } else {
                        ref.read(taskSelectionProvider.notifier)
                            .selectAll(tasks.map((t) => t.id).toList());
                      }
                      // action à definir pour le changement de valeur de la case à cocher
                    },
                    side: BorderSide(
                      // color: AppColors.textDarkSecondary,
                      width: 1,
                    ),
                  ),
                ),
      
              !isSelectionMode
                ? IconButton(
                  onPressed:
                      () {}, // action à definir pour le click sur le boutton des notifications
                  icon: Icon(Icons.notifications_outlined),
                  padding: const EdgeInsets.all(10),
                  iconSize: 28,
                )
                : SizedBox.shrink(),
            ]),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      
            /// SECTION DE RECHERCHE ET DE SORT FILTRAGE
            child: Row(
              children: [
                // Champs de recherche pr filtrer les taches
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).update(value);
                    },
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                        hintText: "Rechercher une tâche, un projet...",
                        hintStyle: TextStyle(
                            color: AppColors.textDarkSecondary, fontSize: 14),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed:() {
                              searchController.clear();
                              ref.read(searchQueryProvider.notifier).update('');
                            },
                          ) 
                        : null,
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
      
                // Boutton pour faire un tri en fonction de la date d'écheance
                SortOrderToggleButtonWidget(onToggle: (isActive) {
                  // action à definir pour le toggle du tri par date d'échéance
                })
              ],
            ),
          ),
      
          /// SECTION DE FILTERS
          SizedBox(
            height: 40,
      
            // Liste horizontale de filtres pour filtrer les tâches. Chaque filtre est représenté par un FilterChipButtonWidget
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: [
                  ...filters.map(
                    (f) => Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FilterChipButtonWidget(
                          label: f.label,
                          isSelected: f.isSelected,
                          onTap: () {
                            ref.read(filterProvider.notifier).select(f.id);
                          },
                        ),
                      ),
                    ),
                  ),
      
                  // Boutton d'ajout de filtre pour permettre à l'utilisateur de créer des filtres personnalisés
                  InkWell(
                    onTap: openAddFilterSheet,
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
              child: tasks.isEmpty
                ? tasksEmptyState()
                : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskListCardView(task: task);
                  }
                ),
            ),
          )
        ]),
      
        floatingActionButton: !isSelectionMode
          ? FloatingActionButton(
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
          )
          : null,
      
        bottomNavigationBar: isSelectionMode
        ? SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomNavigationBarActionButtonWidget(
                    icon: Icons.share_outlined,
                    label: 'Partager',
                    onTap: () => debugPrint("partager"),
                  ),
                  BottomNavigationBarActionButtonWidget(
                    icon: Icons.delete_outline_rounded,
                    label: 'Supprimer',
                    isDelete: true,
                    onTap: () => debugPrint("suprimer"),
                  ),
                ],
              ),
            ),
          )
        : null,
      ),
    );
  }

  Widget tasksEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/tasks_empty_state.svg",
              width: 250,
            ),
            const SizedBox(height: 20),
            Column(
              children: const [
                Text(
                  "Rien à l'horizon !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Votre liste est vide pour le moment. Que planifiez-vous de faire aujourd'hui ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Titre : 
// Sous-titre : Votre liste est vide pour le moment. Que planifiez-vous de faire aujourd'hui ?
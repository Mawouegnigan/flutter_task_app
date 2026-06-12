import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/filter_model.dart';
import 'package:flutter_task_app/providers/filter_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/view/bottom_sheet_add_filter_view.dart';

class AddLabelToTask extends ConsumerStatefulWidget {
  final FilterModel? currentCategory;
  const AddLabelToTask({super.key, this.currentCategory});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddLabelToTaskState();
}

class _AddLabelToTaskState extends ConsumerState<AddLabelToTask> {
  FilterModel _selectedFilter = noneFilter;

  @override
  void initState() {
    super.initState();
    // On initialise avec la catégorie actuelle de la tâche, ou 'noneFilter' par défaut
    _selectedFilter = widget.currentCategory ?? noneFilter;
  }

  void openAddFilterSheet() {
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

  @override
  Widget build(BuildContext context) {
    final customFilters = ref.watch(customFiltersProvider);
    

    return Scaffold(
      appBar: AppBar(
        title: Text("Catégotie"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedFilter),
            child: const Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 8)
      ),
      body: _buildContentState(customFilters, _selectedFilter)
    );
  }

  Widget _buildContentState(List<FilterModel> categorie, FilterModel? selectedCategorie) {
    
    return Column(
      children: [
        // --- Liste des categories ----
        Expanded(
          child: RadioGroup<FilterModel>(
            groupValue: selectedCategorie,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedFilter = value);
              }
            },
            child: ListView.builder(
              itemCount: categorie.length,
              itemBuilder: (context, index) {
                final filter = categorie[index];
                final isNone = filter.id == 'none';

                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      leading: Icon(
                        isNone ? Icons.block_outlined : Icons.label_outline_rounded,
                        size: 28,
                        color: selectedCategorie?.id == filter.id
                            ? AppColors.primary
                            : Colors.grey.shade500,
                      ),
                      title: Text(filter.label),
                      trailing: Transform.scale(
                        scale: 1.3,
                        child: Radio<FilterModel>(
                          value: filter,
                          activeColor: AppColors.primary,
                          side: const BorderSide(width: 0.8),
                        ),
                      ),
                      onTap: () => setState(() => _selectedFilter = filter),
                    ),
                    if (isNone) const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ),

        // --- Bouton ajouter ---
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: openAddFilterSheet,
              icon: const Icon(Icons.add_rounded, size: 32),
              label: const Text('Ajouter une catégorie',
                  style: TextStyle(fontSize: 18)),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
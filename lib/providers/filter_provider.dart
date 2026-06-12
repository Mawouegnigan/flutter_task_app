import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/filter_model.dart';

final defaultFilters = [
  const FilterModel(id: 'all', label: 'Toutes les tâches', isSelected: true),
  const FilterModel(id: 'pending', label: 'En cours'),
  const FilterModel(id: 'done', label: 'Terminées'),
];

class FilterNotifier extends Notifier<List<FilterModel>> {
  @override
  List<FilterModel> build() => defaultFilters;

  void select(String id) {
    state = state.map((f) => f.copyWith(isSelected: f.id == id)).toList();
  }

  void add(String label) {
    final id = 'custom_${label}_${DateTime.now().millisecondsSinceEpoch}';
    state = [...state, FilterModel(id: id, label: label)];
  }

  void remove(String id) {
    final defaultIds = defaultFilters.map((f) => f.id).toSet();

    // Empêche la suppression des filtres par défaut
    if (defaultIds.contains(id)) return;

    state = state.where((f) => f.id != id).toList();
  }
}

final filterProvider = NotifierProvider<FilterNotifier, List<FilterModel>>(
  FilterNotifier.new,
);

final noneFilter = const FilterModel(id: 'none', label: 'Ne pas catégoriser');

final customFiltersProvider = Provider<List<FilterModel>>((ref) {
  final defaultIds = defaultFilters.map((f) => f.id).toSet();
  final customs = ref.watch(filterProvider)
      .where((f) => !defaultIds.contains(f.id))
      .toList();

  return [noneFilter, ...customs];
});
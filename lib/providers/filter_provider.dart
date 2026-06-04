import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/filter_model.dart';

class FilterNotifier extends Notifier<List<FilterModel>> {
  @override
  List<FilterModel> build() => [
    const FilterModel(id: 'all', label: 'Toutes les tâches', isSelected: true),
    const FilterModel(id: 'pending', label: 'En cours'),
    const FilterModel(id: 'done', label: 'Terminées'),
  ];

  void select(String id) {
    state = state.map((f) => f.copyWith(isSelected: f.id == id)).toList();
  }

  void add(String label) {
    final id = 'custom_${label}_${DateTime.now().millisecondsSinceEpoch}';
    state = [...state, FilterModel(id: id, label: label)];
  }
}

final filterProvider = NotifierProvider<FilterNotifier, List<FilterModel>>(
  FilterNotifier.new,
);
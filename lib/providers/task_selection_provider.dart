import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskSelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String taskId) {
    if (state.contains(taskId)) {
      state = {...state}..remove(taskId);
    } else {
      state = {...state, taskId};
    }
  }

  void selectAll(List<String> taskIds) => state = {...taskIds};

  void clearAll() => state = {};

  
}
final taskSelectionProvider = NotifierProvider<TaskSelectionNotifier, Set<String>>(
  TaskSelectionNotifier.new,
);

// Nombre de tâches sélectionnées
final selectedCountProvider = Provider<int>((ref) {
  return ref.watch(taskSelectionProvider).length;
});

// true si toutes les tâches sont sélectionnées
final isAllSelectedProvider = Provider.family<bool, int>((ref, totalCount) {
  final selectedCount = ref.watch(selectedCountProvider);
  return totalCount > 0 && selectedCount == totalCount;
});

final isSelectionModeProvider = Provider<bool>((ref) {
  return ref.watch(taskSelectionProvider).isNotEmpty;
});